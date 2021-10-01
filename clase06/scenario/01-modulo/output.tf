output "public_ip_dev" {
  value = module.webserver-dev.public_ip
}

output "public_ip_prod" {
  value = module.webserver-prod.public_ip
}

