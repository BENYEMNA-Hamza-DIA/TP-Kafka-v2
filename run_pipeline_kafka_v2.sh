#!/bin/bash

bash start_kafka.sh

# 🔹 Création des topics
echo "📌 [INFO] Création des topics..."
bash create_topics.sh

# 🔹 Création des Consumer Groups et démarrage des Consumers
echo "👥 [INFO] Création des Consumer Groups..."
bash create_consumers.sh

# 🔹 Lancer la production automatique de messages
echo "🚀 [INFO] Lancement de la production automatique de messages..."
bash produce_messages_auto.sh

# 🔹 Attente de la fin de la production
echo "⏳ [INFO] Attente de la fin de la production des messages..."
sleep 5

# 🔹 Récupération des messages consommés
echo "📥 [INFO] Récupération des messages consommés..."
bash consume_messages_auto.sh

echo "🔄 [INFO] Vérification et rebalancement des partitions..."
bash rebalance_partitions.sh

echo "✅ [INFO] Pipeline Kafka terminé avec succès !"

#echo "[INFO] Arret des conteneurs !"
#docker-compose down

#echo "[INFO] Suppression des données !"
#docker volume prune -f


