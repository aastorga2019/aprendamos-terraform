resource "docker_image" "proxy_image" {
  name         = "nginx:alpine"
  keep_locally = true
}

# Bien, ahora ocupamos el for_each y con esto bajamos todas las imagenes antes de nada.
resource "docker_image" "backend_image" {
  for_each     = var.image_versiones
  name         = each.value
  keep_locally = true
}

resource "docker_network" "terraform_net" {
  name = "terraform_net"
}

resource "random_string" "backend_name" {
  length  = 3
  special = false

  keepers = {
    env    = join(", ", var.env_var)
    ami_id = var.version_image
  }
}

resource "random_integer" "random_port" {
  min = 16000
  max = 17000

  keepers = {
    env    = join(", ", var.env_var)
    ami_id = var.version_image
  }
}

resource "docker_container" "backend_docker" {
  image   = docker_image.backend_image[var.version_image].latest
  name    = "backend-${random_string.backend_name.result}"
  restart = "always"

  networks_advanced {
    name = docker_network.terraform_net.name
  }

  env = var.env_var

  lifecycle {
    create_before_destroy = true
  }

  provisioner "local-exec" {
    command = "./check_health.sh ${self.ports[0].external}"
  }

  ports {
    internal = 80
    external = random_integer.random_port.result
  }
}

# Con esto creamos un directorio que se va a compartir
# dentro del container. de esta forma cuando se modifica
# un valor no se va a modificar el container.
resource "template_dir" "template_conf" {
  source_dir      = "${path.module}/tpl"
  destination_dir = "${path.module}/conf"

  vars = {
    IP_BACKEND = docker_container.backend_docker.ip_address
  }
}

resource "docker_container" "proxy_docker" {
  image   = docker_image.proxy_image.latest
  name    = "proxy"
  restart = "always"

  # Esto es para montar un volumen de la pc al container
  mounts {
    target    = "/etc/nginx/conf.d/"
    type      = "bind"
    source    = abspath(template_dir.template_conf.destination_dir)
    read_only = true
  }

  ports {
    internal = 80
    external = 9090
  }

  networks_advanced {
    name = docker_network.terraform_net.name
  }

  depends_on = [
    docker_container.backend_docker,
  ]
}

# Todo bien ahora... pero necesitamos que tome la nueva IP, por que no se actualiza solo el nginx.
# Para actualizar el nginx podemos ejecutar el siguiente comando:
# docker exec proxy nginx -s reload
