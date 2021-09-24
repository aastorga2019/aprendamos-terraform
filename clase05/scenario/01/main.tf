resource "docker_image" "proxy_image" {
  name         = "nginx:alpine"
  keep_locally = true
}

resource "docker_image" "backend_image" {
  name         = var.version_image
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

  # Aqui corremos el check sobre la aplicacion,
  # dado a que esto lo corremos en mac, vamos a
  # tener que abrir un puerto con el nodo, y 
  # por eso ocupamos el hosts.
  provisioner "local-exec" {
    command = "./check_health.sh ${self.ports[0].external}"
  }

  # Puerto con el master.
  ports {
    internal = 80
    external = 16000
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
}

# Y ahora, como podemos hacer para no tener tanto downtime mientras se recrea el backend?
