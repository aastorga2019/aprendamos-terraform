resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sub_network" {
  name          = "sub-network"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "fw_access_80_22" {
  name        = "accesstovm"
  network     = google_compute_network.vpc_network.self_link
  description = "Acceso al webserver por puerto 80 y 22"

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
  target_tags = ["webserver"]
}

resource "google_compute_instance" "webserver" {
  name         = "webserver"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  tags = ["webserver", "mywebserver"]

  boot_disk {
    initialize_params {
      image = "projects/confidential-vm-images/global/images/cos-stable-89-16108-534-8"
    }
  }

  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.sub_network.self_link

    access_config {
    }
  }

  metadata_startup_script = templatefile("${path.module}/initial_script.sh", { DOCKER_IMAGE = "${var.docker_image}" })
}
