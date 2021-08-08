variable "users" {
  type = list(object({
    nombre = string
    grants = list(string)
  }))
  default = [
    {
      nombre = "pedro",
      grants = ["SELECT"]
    },
    {
      nombre = "vilma",
      grants = ["SELECT", "UPDATE", "INSERT"]
    },
    {
      nombre = "pablo",
      grants = ["SELECT", "CREATE"]
    },
    {
      nombre = "betty",
      grants = ["SELECT", "DROP"]
    }
  ]
}
