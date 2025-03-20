#!/bin/bash

sudo bash start_kafka.sh


# 🔹 Création des topics
echo "📌 [INFO] Création des topics..."
sudo bash create_topics.sh


# 🔹 Création des Consumer Groups et démarrage des Consumers
echo "👥 [INFO] Création des Consumer Groups..."
sudo bash create_consumers.sh


# 🔹 Lancer la production automatique de messages
echo "🚀 [INFO] Lancement de la production automatique de messages..."
sudo bash produce_messages_auto.sh
sleep 5


# Test de failover
echo "❗⚠️ [INFO] On simule une panne en arretant le noeud actif kafka1"
sudo docker-compose stop kafka1
sleep 5


#echo "✅ Les consumers actifs seront basculés vers un autre noeud disponible"
sleep 5


# 🔹 Lancer la production automatique de messages
echo "🚀 [INFO] Lancement de la production automatique de messages après fail over... (2/2)"
sudo bash produce_messages_auto.sh


echo "Attente de la fin de consommation des messages"
sleep 5


# 🔹 Récupération des messages consommés
#echo "📥 [INFO] Récupération des messages consommés..."
#sudo bash consume_messages_auto.sh


echo "✅ [INFO] Pipeline Kafka terminé avec succès !"


#echo "[INFO] Arret des conteneurs !"
#docker-compose down

#echo "[INFO] Suppression des données !"
#docker volume prune -f


