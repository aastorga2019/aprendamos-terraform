form-google-k8s-ebz
examples
minimal
main.tf
Jorge Rojas R's avatar
fix: Corrige ejemplo minimal (XPCLIN-744)
jorgefelipe.rojas@latam.com authored 10 months ago
7d6cf503
 Code owners
Assign users and groups as approvers for specific file changes. Learn more.
main.tf
493 B
module "gke" {
  source           = "../../"
  cluster_name     = var.cluster_name
  cluster_location = var.cluster_location
  ip_range         = var.ip_range
  ## Para No tener autoscaling hay que descomentar estas lineas
  #autoscaling      = false
  #node_count       = 8
  # Para TENER autoscaling
  autoscaling    = true
  min_node_count = 2
  max_node_count = 4
}
/*
output "cluster_name" {
  value = module.gke.cluster_name
}
output "endpoint" {
  value = module.gke.endpoint
}
*/