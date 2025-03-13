#!/bin/bash

declare -A CONSUMERS_GROUPS
CONSUMERS_GROUPS["topic1"]=1
CONSUMERS_GROUPS["topic2"]=2
CONSUMERS_GROUPS["topic3"]=3

KAFKA_CONTAINER="kafka1"
BOOTSTRAP_SERVER="kafka1:9092"

echo "👥 [INFO] Création des Consumer Groups..."
for topic in "${!CONSUMERS_GROUPS[@]}"; do
    GROUP_NAME="group_$topic"
    NUM_CONSUMERS=${CONSUMERS_GROUPS[$topic]}

    echo "🔹 Consumer Group créé : $GROUP_NAME pour $topic"

    for (( i=1; i<=NUM_CONSUMERS; i++ )); do
        echo "🎧 [INFO] Démarrage du Consumer $i dans $GROUP_NAME..."
        docker-compose exec -T $KAFKA_CONTAINER kafka-console-consumer --topic $topic --group $GROUP_NAME --bootstrap-server $BOOTSTRAP_SERVER > "consumer_${GROUP_NAME}_${i}.log" 2>&1 &
    done
done
