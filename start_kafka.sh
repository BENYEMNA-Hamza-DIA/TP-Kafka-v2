#!/bin/bash

echo "🚀 [INFO] Initialisation du pipeline Kafka..."

# 🔹 Démarrer les conteneurs avec Docker Compose
echo "🛠️ [INFO] Démarrage de Kafka, Prometheus, Grafana..."
docker-compose up -d

# 🔹 Attendre que Kafka soit prêt via HAProxy
echo "⏳ [INFO] Vérification de la disponibilité de Kafka via kafka-lb..."

MAX_RETRIES=15
RETRY_INTERVAL=5
SUCCESS=false

for i in $(seq 1 $MAX_RETRIES); do
    if docker-compose exec -T kafka1 kafka-topics --bootstrap-server kafka-lb:9092 --list &>/dev/null; then
        echo "✅ [INFO] Kafka est accessible via kafka-lb !"
        SUCCESS=true
        break
    fi
    echo "⏳ [ATTENTE] Kafka n'est pas encore prêt via kafka-lb... Retente dans $RETRY_INTERVAL secondes ($i/$MAX_RETRIES)"
    sleep $RETRY_INTERVAL
done

if [ "$SUCCESS" = false ]; then
    echo "❌ [ERREUR] Kafka n'a pas réussi à démarrer après $MAX_RETRIES tentatives."
    exit 1
fi

echo "🎉 [SUCCESS] Tous les services sont opérationnels ! 🚀"
