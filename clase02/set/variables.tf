variable "fruit" {
	default = ["apple", "banana"]
	type = set(string)
}

output "my_out" {
	value = var.fruit
}
