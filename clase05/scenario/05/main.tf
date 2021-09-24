resource "docker_image" "proxy_image" {
  name         = "nginx:alpine"
  keep_locally = true
}

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
    template_dir.template_conf,
  ]
}

# Con esto lo que hacemos es que cada vez que se actualiza la imagen del backend, vamos a hacer un reload de nginx.
resource "null_resource" "cluster" {
  triggers = {
    new_file  = template_dir.template_conf.vars["IP_BACKEND"]
    new_proxy = docker_container.proxy_docker.ip_address
  }

  provisioner "local-exec" {
    command = "docker exec proxy nginx -s reload"
  }

  depends_on = [
    template_dir.template_conf,
  ]
}
