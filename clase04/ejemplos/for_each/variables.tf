variable "filename" {
  type = set(string)
  default = [
    "pets.txt",
    "dogs.txt",
    "cats.txt"
  ]
}
