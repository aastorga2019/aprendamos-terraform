terraform {
  required_providers {
    docker = "kreuzwerker/docker:27"
#    docker = {
#      source  = "kreuzwerker/docker"
#      version = "2.14.0"
#    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
