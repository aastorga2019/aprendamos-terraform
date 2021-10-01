
###################################################
###########Esto es para la parte de dev############
###################################################
resource "google_compute_network" "vpc_network_dev" {
  name                    = "vpc-network-dev"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sub_network_dev" {
  name          = "sub-network-dev"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network_dev.id
}

resource "google_compute_firewall" "fw_access_80_22_dev" {
  name        = "accesstovm-dev"
  network     = google_compute_network.vpc_network_dev.self_link
  description = "Acceso al webserver por puerto 80 y 22 pero en dev"

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
  target_tags = ["webserverdev"]
}

resource "google_compute_instance" "webserver_dev" {
  name         = "webserver-dev"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  tags = ["webserverdev", "mywebserver"]

  boot_disk {
    initialize_params {
      image = "projects/confidential-vm-images/global/images/cos-stable-89-16108-534-8"
    }
  }

  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network    = google_compute_network.vpc_network_dev.self_link
    subnetwork = google_compute_subnetwork.sub_network_dev.self_link

    access_config {
    }
  }

  metadata_startup_script = templatefile("${path.module}/initial_script.sh", { DOCKER_IMAGE = "${var.docker_image_dev}" })
}

####################################################
###########Esto es para la parte de prod############
####################################################
resource "google_compute_network" "vpc_network_prod" {
  name                    = "vpc-network-prod"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sub_network_prod" {
  name          = "sub-network-prod"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network_prod.id
}

resource "google_compute_firewall" "fw_access_80_22_prod" {
  name        = "accesstovm-prod"
  network     = google_compute_network.vpc_network_prod.self_link
  description = "Acceso al webserver por puerto 80 y 22 en prod"

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
  target_tags = ["webserverprod"]
}

resource "google_compute_instance" "webserver_prod" {
  name         = "webserver-prod"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  tags = ["webserverprod", "mywebserver"]

  boot_disk {
    initialize_params {
      image = "projects/confidential-vm-images/global/images/cos-stable-89-16108-534-8"
    }
  }

  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network    = google_compute_network.vpc_network_prod.self_link
    subnetwork = google_compute_subnetwork.sub_network_prod.self_link

    access_config {
    }
  }

  metadata_startup_script = templatefile("${path.module}/initial_script.sh", { DOCKER_IMAGE = "${var.docker_image_prod}" })
}

