terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  credentials = file(var.google_credentials)
  project     = var.gcp_project
  region      = var.gcp_region
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

  metadata_startup_script = file("${path.module}/scripts/setup_kafka.sh")
}

resource "google_compute_firewall" "allow_kafka_services" {
  name    = "allow-kafka-services"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = var.allowed_ports
  }

  source_ranges = ["0.0.0.0/0"]
}

output "instance_ip" {
  value       = google_compute_instance.kafka_vm.network_interface[0].access_config[0].nat_ip
  description = "Public IP of the Kafka VM"
}
