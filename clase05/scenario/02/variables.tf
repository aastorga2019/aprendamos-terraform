variable "version_image" {
  default = "quinont/aprendamos_terraform:1"
}

variable "env_var" {
  default = [
    "prueba=1244",
    "algo=123"
  ]
}
