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

 metadata_startup_script = <<-EOT
    #!/bin/bash
    echo "🚀 [INFO] Installation des dépendances pour le déploiement Kafka + Monitoring"

    # 🔹 Mise à jour des paquets
    sudo apt update && sudo apt upgrade -y

    # 🔹 Installation de Java 17
    sudo apt install -y openjdk-17-jdk
    java -version

    # 🔹 Installation de Docker
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    # 🔹 Ajout de l'utilisateur courant au groupe Docker
    sudo usermod -aG docker $USER
    newgrp docker

    # 🔹 Installation de Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version

    # 🔹 Activation et démarrage du service Docker
    sudo systemctl enable docker
    sudo systemctl start docker

    # 🔹 Vérification des versions installées
    docker --version
    java -version

    # 🔹 Cloner le repo contenant les scripts Kafka
    cd /home/
    git clone https://github.com/BENYEMNA-Hamza-DIA/TP-Kafka-v2.git
    cd TP-Kafka-v2

    # 🔹 Rendre tous les scripts exécutables
    chmod +x *.sh

    # 🔹 Lancer Docker Compose
    docker-compose up -d

    # 🔹 Firewall : Ouverture des ports si UFW est actif
    if sudo ufw status | grep -q "active"; then
        sudo ufw allow 9092/tcp   # HAProxy
        sudo ufw allow 9095/tcp   # Kafka1
        sudo ufw allow 9093/tcp   # Kafka2
        sudo ufw allow 9094/tcp   # Kafka3
        sudo ufw allow 2181/tcp   # Zookeeper
        sudo ufw allow 3000/tcp   # Grafana
        sudo ufw allow 9090/tcp   # Prometheus
        sudo ufw allow 8080/tcp   # Kafka UI
        sudo ufw allow 9308/tcp   # Kafka Exporter
        sudo ufw reload
    fi

    echo "✅ [INFO] Installation terminée avec succès ! Vous pouvez maintenant exécuter votre pipeline Kafka."
  EOT
  
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