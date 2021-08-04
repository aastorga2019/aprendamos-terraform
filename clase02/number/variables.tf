variable "length" {
  default     = "1"
  type        = number
  description = "length of the pet name"
}

output "my_out" {
	value = var.length
}
