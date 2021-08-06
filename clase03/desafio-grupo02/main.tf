resource "docker_image" "db_image" {
  name = "mysql:8.0.19"
}

resource "docker_image" "wp_image" {
  name = "wordpress:latest"
}

resource "random_password" "admin_db_password" {
  length           = 16
  special          = true
  override_special = "_!@"
}

resource "docker_volume" "db_data" {
  name = "db_data"
}

resource "docker_network" "wp_net" {
  name = "wp_net"
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
    "MYSQL_DATABASE=wp1"
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
    name    = docker_network.wp_net.name
    aliases = ["db"]
  }

}

resource "docker_container" "wp_docker" {
  image   = docker_image.wp_image.latest
  name    = "wp"
  restart = "always"

  env = [
    "WORDPRESS_DB_HOST=db",
    "WORDPRESS_DB_USER=root",
    "WORDPRESS_DB_PASSWORD_FILE=/run/secrets/db-password"
  ]

  upload {
    content = random_password.admin_db_password.result
    file    = "/run/secrets/db-password"
  }

  ports {
    internal = 80
    external = 8080
  }

  networks_advanced {
    name    = docker_network.wp_net.name
    aliases = ["wp"]
  }

}
