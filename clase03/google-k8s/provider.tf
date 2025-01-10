
170 B
provider "google" {
  project = var.project_id
  region  = var.cluster_location
}
provider "google-beta" {
  project = var.project_id
  region  = var.cluster_location
}