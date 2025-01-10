variable "fruit" {
	default = ["apple", "banana", 3]
	type = set(string)
}

output "my_out" {
	value = var.fruit
}
