terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.14.0"
    }
    mysql = {
      source  = "winebarrel/mysql"
      version = "1.10.5"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

provider "mysql" {
  endpoint = "localhost:3306"
  username = "root"
  password = random_password.admin_db_password.result
}
