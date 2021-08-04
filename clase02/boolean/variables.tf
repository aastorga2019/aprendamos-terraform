variable "password_chage" {
	default = "true"
	type = bool
}

output "my_salida" {
	value = var.password_chage
}
