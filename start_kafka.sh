#!/bin/bash

echo "🚀 [INFO] Initialisation du pipeline Kafka..."

# 🔹 Vérifier si le réseau Docker kafka_network existe, sinon le créer
NETWORK_NAME="kafka_network"

if ! docker network inspect $NETWORK_NAME &>/dev/null; then
    echo "🔄 [INFO] Création du réseau Docker : $NETWORK_NAME"
    docker network create $NETWORK_NAME
else
    echo "✅ [INFO] Réseau $NETWORK_NAME déjà existant"
fi

# 🔹 Démarrer les conteneurs avec Docker Compose
echo "🛠️ [INFO] Démarrage de Kafka, Prometheus, Grafana..."
docker-compose up -d

# 🔹 Attendre que tous les conteneurs soient bien "running"
echo "⏳ [INFO] Vérification de l'état des conteneurs..."
sleep 5
for container in kafka1 kafka2 kafka3 prometheus grafana kafka-exporter; do
    echo "🔍 [INFO] Vérification de $container..."
    while ! docker inspect -f '{{.State.Running}}' $container &>/dev/null || [ "$(docker inspect -f '{{.State.Running}}' $container)" != "true" ]; do
        echo "⏳ [ATTENTE] $container n'est pas encore prêt... Retente dans 3s"
        sleep 3
    done
    echo "✅ [OK] $container est prêt !"
done

# 🔹 Vérifier et ajouter les conteneurs au réseau si nécessaire
CONTAINERS=("kafka1" "kafka2" "kafka3" "prometheus" "grafana" "kafka-exporter")

for container in "${CONTAINERS[@]}"; do
    if ! docker network inspect $NETWORK_NAME | grep -q "$container"; then
        echo "🔗 [INFO] Ajout du conteneur $container au réseau $NETWORK_NAME..."
        docker network connect $NETWORK_NAME $container
    else
        echo "✅ [INFO] Conteneur $container déjà connecté à $NETWORK_NAME"
    fi
done

# 🔹 Attente dynamique pour que Kafka soit réellement prêt
echo "⏳ [INFO] Vérification de la disponibilité de Kafka..."
MAX_RETRIES=10
RETRY_INTERVAL=5
for i in $(seq 1 $MAX_RETRIES); do
    if docker-compose exec -T kafka1 kafka-topics --bootstrap-server kafka1:9092 --list &>/dev/null; then
        echo "✅ [INFO] Kafka est accessible !"
        break
    fi
    echo "⏳ [ATTENTE] Kafka n'est pas encore prêt... Retente dans $RETRY_INTERVAL secondes ($i/$MAX_RETRIES)"
    sleep $RETRY_INTERVAL
done