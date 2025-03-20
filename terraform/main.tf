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

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/id_rsa"
  file_permission = "0600"
}

resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "${path.module}/id_rsa.pub"
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

  metadata = {
    ssh-keys = "ubuntu:${tls_private_key.ssh_key.public_key_openssh}"
    user-data = <<-EOT
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - git
    runcmd:
      - systemctl enable docker
      - systemctl start docker
      - git clone https://github.com/BENYEMNA-Hamza-DIA/TP-Kafka-v2.git /home/ubuntu/TP-Kafka-v2
      - chmod +x /home/ubuntu/TP-Kafka-v2/*.sh
      - /home/ubuntu/TP-Kafka-v2/installation_dependencies.sh
      - /home/ubuntu/TP-Kafka-v2/run_pipeline_kafka_v2.sh

  EOT
  
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