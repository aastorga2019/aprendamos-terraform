output "public_ip_dev" {
  value = google_compute_instance.webserver_dev.network_interface.0.access_config.0.nat_ip
}

output "public_ip_prod" {
  value = google_compute_instance.webserver_prod.network_interface.0.access_config.0.nat_ip
}

