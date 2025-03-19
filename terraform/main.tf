terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
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

  metadata_startup_script = <<-EOT
    #!/bin/bash
    echo "🚀 [INFO] Démarrage de l'installation et du pipeline Kafka"
    
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y git
    
    cd /home/
    git clone https://github.com/BENYEMNA-Hamza-DIA/TP-Kafka-v2.git
    cd TP-Kafka-v2
    
    chmod +x *.sh
    ./installation_dependencies.sh
    ./run_pipeline_kafka_v2.sh
    
    echo "✅ [INFO] Déploiement terminé"
  EOT
}

output "instance_ip" {
  value       = google_compute_instance.kafka_vm.network_interface[0].access_config[0].nat_ip
  description = "Public IP of the Kafka VM"
}

output "ssh_connection" {
  value       = "gcloud compute ssh ${google_compute_instance.kafka_vm.name} --zone=${var.gcp_zone}"
  description = "Command to SSH into the Kafka VM"
}