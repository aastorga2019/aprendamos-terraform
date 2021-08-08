variable "users" {
  type = map(list(string))
  default = {
    "pedro" : ["SELECT"],
    "vilma" : ["SELECT", "UPDATE", "INSERT"],
    "pablo" : ["SELECT", "CREATE"],
    "betty" : ["SELECT", "DROP"]
  }
}
