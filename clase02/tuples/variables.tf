variable yosie {
	type = tuple([string, number, bool])
	default = ["dog", 7, true]
}

output "my_salida" {
	value = var.yosie[1]
}
