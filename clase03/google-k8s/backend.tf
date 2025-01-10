terraform {
  backend "gcs" {
    bucket = "terraform-latamxp-sandbox"
    prefix = "terrform-google-k8s/examples/minimal"
  }
}
