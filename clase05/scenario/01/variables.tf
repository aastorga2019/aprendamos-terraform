variable "version_image" {
  default = "quinont/aprendamos_terraform:1"
}

variable "env_var" {
  default = [
    "hola=12",
    "algo=123"
  ]
}
