#!/bin/bash

TOPICS=("topic1" "topic2" "topic3")
BOOTSTRAP_SERVER="kafka-lb:9092"

echo "📌 Création des topics..."
for topic in "${TOPICS[@]}"; do
    docker-compose exec kafka1 kafka-topics --create --if-not-exists --topic $topic --partitions 3 --replication-factor 3 --bootstrap-server $BOOTSTRAP_SERVER
    echo "✅ Topic créé : $topic"
done
