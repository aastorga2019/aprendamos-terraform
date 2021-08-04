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

  upload {
    content = data.template_file.template_index.rendered
    file    = "/usr/share/nginx/html/index.html"
  }
}

data "template_file" "template_index" {
  template = file("${path.module}/index.html")
  vars = {
    PERSONA_A_SALUDAR = "Aprendamos Terraform"
  }
}
