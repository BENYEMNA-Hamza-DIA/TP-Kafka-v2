#!/bin/bash

echo "♻️ [INFO] Vérification des partitions sous-répliquées..."

docker-compose exec -T kafka1 kafka-topics --bootstrap-server kafka-lb:9092 --describe | grep "UnderReplicated"

if [ $? -eq 0 ]; then
    echo "⚠️ [WARNING] Certaines partitions sont sous-répliquées. Réassignation en cours..."
    docker-compose exec -T kafka1 kafka-reassign-partitions --bootstrap-server kafka-lb:9092 --execute
else
    echo "✅ [INFO] Toutes les partitions sont bien répliquées."
fi
