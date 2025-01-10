variable "length" {
  default     = "1"
  type        = number
  description = "length of the pet name"
}

variable "length2" {
  default     = 2
  type        = string
}

output "my_out" {
	value = var.length
}

output "my_out2" {
	value = var.length2
}
