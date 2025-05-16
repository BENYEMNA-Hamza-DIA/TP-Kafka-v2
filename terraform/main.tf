terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

## Déploiement sur Github Actions
##
provider "google" {
  credentials = var.google_credentials
  project     = var.gcp_project
  region      = var.gcp_region
}
##

## Deploiement local
##
#provider "google" {
#  credentials = file(local.credentials_file_path)
#  project     = var.gcp_project
#  region      = var.gcp_region
#}
##


resource "google_compute_firewall" "allow_kafka_services" {
  name    = "allow-kafka-services"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = var.allowed_ports
  }

  source_ranges = ["0.0.0.0/0"]

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [
      allow,
      source_ranges,
    ]
  }
}



resource "google_compute_instance" "kafka_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = var.os_image
      size  = var.disk_size
    }
  }


  network_interface {
    network = "default"
    access_config {}
  }

}


output "instance_ip" {
  value       = google_compute_instance.kafka_vm.network_interface[0].access_config[0].nat_ip
  description = "Public IP of the Kafka VM"
}


output "ssh_connection" {
  value       = "gcloud compute ssh ${google_compute_instance.kafka_vm.name} --zone=${var.gcp_zone}"
  description = "Command to SSH into the Kafka VM"
}