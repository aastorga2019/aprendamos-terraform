variable "cluster_name" {
  type        = string
  description = "Nombre del cluster GKE a crear"
  default     = "ejemplo"
}

variable "cluster_location" {
  type        = string
  description = "Zona o Región del cluster GKE a crear"
  default     = "us-east1"
}

variable "project_id" {
  type        = string
  description = "Proyecto GCP del cluster GKE a crear"
  default     = "latamxp-sandbox"
}

variable "ip_range" {
  type        = string
  description = "Rango de IPs para los pods del cluster GKE"
  default     = "10.0.0.0/8"
}
