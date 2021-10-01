###################################################
###########Esto es para la parte de dev############
###################################################
module "webserver-dev" {
  source = "./webserver/"

  ambiente     = "dev"
  docker_image = var.docker_image_dev
}

####################################################
###########Esto es para la parte de prod############
####################################################
module "webserver-prod" {
  source = "./webserver/"

  ambiente     = "prod"
  docker_image = var.docker_image_prod
}

