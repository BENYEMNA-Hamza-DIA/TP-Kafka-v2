# =============================
# PROVIDER CONFIGURATION
# =============================
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  credentials = file(env("GOOGLE_APPLICATION_CREDENTIALS"))
  project     = "mon-projet-kafka"
  region      = "europe-west9"
}


# =============================
# CREATE A VM INSTANCE IN PARIS REGION
# =============================
resource "google_compute_instance" "kafka_vm" {
  name         = "kafka-instance"
  machine_type = "e2-medium" 
  # 2 vCPU, 4GB RAM
  
  zone         = "europe-west9-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 30  
      # 30GB Disk Storage
    }
  }

  network_interface {
    network = "default"
    access_config {}  # Assign a public IP
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    echo "🚀 [INFO] Installation des dépendances pour le déploiement Kafka + Monitoring"

    # 🔹 Mise à jour des paquets
    echo "🔄 [INFO] Mise à jour des paquets..."
    sudo apt update && sudo apt upgrade -y

    # 🔹 Installation de Java 17
    echo "☕ [INFO] Installation de Java 17..."
    sudo apt install -y openjdk-17-jdk
    java -version

    # 🔹 Installation de Docker
    echo "🐳 [INFO] Installation de Docker..."
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    # 🔹 Ajout de l'utilisateur courant au groupe Docker
    echo "👤 [INFO] Ajout de l'utilisateur courant au groupe Docker..."
    sudo usermod -aG docker $USER
    newgrp docker

    # 🔹 Installation de Docker Compose
    echo "📦 [INFO] Installation de Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version

    # 🔹 Activation et démarrage du service Docker
    echo "🚀 [INFO] Activation et démarrage de Docker..."
    sudo systemctl enable docker
    sudo systemctl start docker

    # 🔹 Vérification des versions installées
    echo "✅ [INFO] Vérification des installations..."
    docker --version
    java -version

    # 🔹 Cloner le repo contenant les scripts Kafka
    echo "📥 [INFO] Clonage du repo Kafka..."
    cd /home/
    git clone https://github.com/BENYEMNA-Hamza-DIA/TP-Kafka-v2.git
    cd TP-Kafka-v2

    # 🔹 Rendre tous les scripts exécutables
    echo "🔑 [INFO] Rendre tous les scripts exécutables..."
    chmod +x *.sh

    echo "✅ [INFO] Installation terminée avec succès ! Vous pouvez maintenant exécuter votre pipeline Kafka."
  EOT
}

# =============================
# FIREWALL RULES FOR ACCESSING SERVICES
# =============================
resource "google_compute_firewall" "allow_kafka_services" {
  name    = "allow-kafka-services"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080", "9090", "3000", "9092", "9095", "9093", "9094", "2181", "9308"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# =============================
# OUTPUT VM PUBLIC IP
# =============================
output "instance_ip" {
  value       = google_compute_instance.kafka_vm.network_interface[0].access_config[0].nat_ip
  description = "Public IP of the Kafka VM"
}