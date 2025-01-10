resource "local_file" "my-pet" {
  filename = "ppets.txt"
  content  = var.file-content["statement1"]
}
