resource "docker_image" "proxy_image" {
  name         = "nginx:alpine"
  keep_locally = true
}

resource "docker_image" "backend_image" {
  name         = "quinont/aprendamos_terraform:1"
  keep_locally = true
}

resource "docker_network" "terraform_net" {
  name = "terraform_net"
}

resource "docker_container" "backend_docker" {
  image   = docker_image.backend_image.latest
  name    = "backend"
  restart = "always"

  networks_advanced {
    name = docker_network.terraform_net.name
  }

  env = var.env_var
}

resource "docker_container" "proxy_docker" {
  image   = docker_image.proxy_image.latest
  name    = "proxy"
  restart = "always"

  upload {
    content = templatefile("${path.module}/default.conf.tpl", {IP_BACKEND = "${docker_container.backend_docker.ip_address}"})
    file    = "/etc/nginx/conf.d/default.conf"
  }

  ports {
    internal = 80
    external = 9090
  }

  networks_advanced {
    name = docker_network.terraform_net.name
  }
}

# Ahora, podemos agregar un heatlh check hasta que la app este funcionando?
