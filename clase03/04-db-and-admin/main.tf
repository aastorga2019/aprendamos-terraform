resource "docker_image" "db_image" {
  name = "mysql:8.0.19"
}

resource "docker_image" "phpmyadmin_image" {
  name = "phpmyadmin/phpmyadmin:5.1.1"
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
  restart = "always"

  volumes {
    container_path = "/var/lib/mysql"
    volume_name    = docker_volume.db_data.name
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.admin_db_password.result}",
    "MYSQL_DATABASE=example"
  ]

  ports {
    internal = 3306
    external = 3306
  }

  networks_advanced {
    name    = docker_network.terraform_net.name
    aliases = ["db"]
  }

}

resource "docker_container" "phpmyadmin_docker" {
  image   = docker_image.phpmyadmin_image.latest
  name    = "backend"
  restart = "always"

  env = [
    "PMA_HOSTS=db",
    "PMA_PORTS=3306"
  ]

  networks_advanced {
    name    = docker_network.terraform_net.name
    aliases = ["phpmyadmin"]
  }

  ports {
    internal = 80
    external = 9090
  }

  depends_on = [
    docker_container.db_docker,
  ]
}

