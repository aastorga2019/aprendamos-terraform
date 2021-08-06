resource "docker_image" "db_image" {
  name = "mysql:8.0.19"
}

resource "docker_image" "backend_image" {
  name = "quinont/awesome-compose-backend:1"
}

resource "docker_image" "proxy_image" {
  name = "nginx:alpine"
}

resource "random_password" "admin_db_password" {
  length           = 16
  special          = true
  override_special = "_!@"
}

resource "docker_volume" "db_data" {
  name = "db_data"
}

resource "docker_network" "terraform_net" {
  name = "terraform_net"
}

resource "docker_container" "db_docker" {
  image   = docker_image.db_image.latest
  name    = "db"
  command = ["--default-authentication-plugin=mysql_native_password"]
  restart = "always"

  volumes {
    container_path = "/var/lib/mysql"
    volume_name    = docker_volume.db_data.name
  }

  env = [
    "MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db-password",
    "MYSQL_DATABASE=example"
  ]

  upload {
    content = random_password.admin_db_password.result
    file    = "/run/secrets/db-password"
  }

  ports {
    internal = 3306
    external = 3306
  }

  networks_advanced {
    name    = docker_network.terraform_net.name
    aliases = ["db"]
  }

}

resource "docker_container" "backend_docker" {
  image   = docker_image.backend_image.latest
  name    = "backend"
  restart = "always"

  upload {
    content = random_password.admin_db_password.result
    file    = "/run/secrets/db-password"
  }

  networks_advanced {
    name    = docker_network.terraform_net.name
    aliases = ["backend"]
  }

  depends_on = [
    docker_container.db_docker,
  ]
}

resource "docker_container" "proxy_docker" {
  image   = docker_image.proxy_image.latest
  name    = "proxy"
  restart = "always"

  upload {
    content = file("${path.module}/default.conf")
    file    = "/etc/nginx/conf.d/default.conf"
  }

  ports {
    internal = 80
    external = 9090
  }

  networks_advanced {
    name    = docker_network.terraform_net.name
    aliases = ["proxy"]
  }

  depends_on = [
    docker_container.backend_docker,
  ]
}
