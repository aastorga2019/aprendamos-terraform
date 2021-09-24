resource "local_file" "pet" {
	filename = "pets.txt"
	content = "We love pets!"
    file_permission = "0755"
    
    lifecycle {
        prevent_destroy = true
    }
}