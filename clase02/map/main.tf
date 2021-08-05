resource "local_file" "my-pet" {
  filename = "pets.txt"
  content  = var.file-content["statement1"]
}
