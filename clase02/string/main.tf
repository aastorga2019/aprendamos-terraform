resource "local_file" "devs" {
	filename = var.filename
	content = var.content
}
