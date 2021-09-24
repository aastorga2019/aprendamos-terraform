variable "image_versiones" {
  default = {
    "1" : "quinont/aprendamos_terraform:1",
    "2" : "quinont/aprendamos_terraform:2"
  }
}

variable "version_image" {
  default = "1"
}

variable "env_var" {
  default = [
    "hola=12",
    "algo=123"
  ]
}
