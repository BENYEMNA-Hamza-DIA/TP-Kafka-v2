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
sudo apt install -y docker


# 🔹 Ajout de l'utilisateur courant au groupe Docker
echo "👤 [INFO] Ajout de l'utilisateur courant au groupe Docker..."
sudo usermod -aG docker $USER
newgrp docker


# 🔹 Installation de Docker Compose
echo "📦 [INFO] Installation de Docker Compose..."
sudo apt install -y docker-compose
docker-compose --version


# 🔹 Activation et démarrage du service Docker
echo "🚀 [INFO] Activation et démarrage de Docker..."
sudo systemctl enable docker
sudo systemctl start docker


# 🔹 Vérification des versions installées
echo "✅ [INFO] Vérification des installations..."
docker --version
java -version


# 🔹 Rendre les scripts exécutables
echo "🔑 [INFO] Rendre tous les scripts exécutables..."
chmod +x *.sh


# 🔹 Firewall : Ouverture des ports si UFW est actif
if sudo ufw status | grep -q "active"; then
    echo "🔓 [INFO] Ouverture des ports nécessaires..."
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

