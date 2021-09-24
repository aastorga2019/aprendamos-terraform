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

resource "docker_container" "proxy_docker" {
  image   = docker_image.proxy_image.latest
  name    = "proxy"
  restart = "always"

  upload {
    content = templatefile("${path.module}/default.conf.tpl", { IP_BACKEND = "${docker_container.backend_docker.ip_address}" })
    file    = "/etc/nginx/conf.d/default.conf"
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

#  Bueno ahora si vamos al problema...
