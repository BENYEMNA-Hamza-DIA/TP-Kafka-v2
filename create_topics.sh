#!/bin/bash

TOPICS=("topic1" "topic2" "topic3")
KAFKA_CONTAINER="kafka1"
BOOTSTRAP_SERVER="kafka1:9092"

echo "📌 Création des topics..."
for topic in "${TOPICS[@]}"; do
    docker-compose exec kafka1 kafka-topics --create --if-not-exists --topic $topic --partitions 3 --replication-factor 2 --bootstrap-server $BOOTSTRAP_SERVER
    echo "✅ Topic créé : $topic"
done
