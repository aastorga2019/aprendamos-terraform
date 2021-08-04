resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "mycontainer" {
  image = docker_image.nginx.latest
  name  = "nginx"

  ports {
    internal = 80
    external = 9090
  }
}
