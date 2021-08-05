variable "file-content" {
  type = map(any)
  default = {
    "statement1" = "We love pets!"
    "statement2" = "We love animals!"
  }
}
