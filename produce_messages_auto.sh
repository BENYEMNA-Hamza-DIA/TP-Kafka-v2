#!/bin/bash

# 🔹 Configuration
KAFKA_CONTAINER="kafka1"
BOOTSTRAP_SERVER="kafka1:9092"
TOPICS=("topic1" "topic2" "topic3")
DURATION=300  # Durée en secondes (ex: 5 minutes)
INTERVAL=5  # Intervalle en secondes entre chaque message

echo "📤 [INFO] Début de la production automatique de messages sur $DURATION secondes..."

START_TIME=$(date +%s)

while (( $(date +%s) - START_TIME < DURATION )); do
    RANDOM_TOPIC=${TOPICS[$RANDOM % ${#TOPICS[@]}]}
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    MESSAGE="Message aléatoire - $TIMESTAMP"

    echo "$MESSAGE" | docker-compose exec -T $KAFKA_CONTAINER kafka-console-producer \
        --bootstrap-server $BOOTSTRAP_SERVER \
        --topic $RANDOM_TOPIC
    echo "✅ [Envoyé] $MESSAGE → $RANDOM_TOPIC"

    sleep $INTERVAL
done

echo "🛑 [INFO] Fin de la production automatique après $DURATION secondes."
