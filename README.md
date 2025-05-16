# Kafka Hands-on Training - Wavestone Cloud Forward 🚀

## 🏆 Goal of the Training

Ce hands-on a pour but de déployer un cluster Kafka complet sur GCP via Terraform, avec producteurs, topics, messages et groupes de consommateurs. Ce TP vous permettra de comprendre le fonctionnement interne de Kafka et les avantages des architectures event-driven.

---

## 📀 Introduction : Event-Driven Architecture (EDA)

### ⚖️ Principe

Une architecture orientée événements repose sur la production, la détection et la réaction à des événements. Les services communiquent en échangeant des messages plutôt qu'en faisant des requêtes directes.

### ✨ Avantages

* Découplage fort entre les services
* Haute scalabilité
* Temps réel
* Extensibilité facilitée

### 🏛️ Use cases

* Traitement de logs
* Monitoring en temps réel
* Applications bancaires (transactions)
* Intégration de microservices

### 🌍 Comparaison avec API REST

| Aspect      | API REST          | Event-driven           |
| ----------- | ----------------- | ---------------------- |
| Couplage    | Fort              | Faible                 |
| Mode        | Pull              | Push                   |
| Réactivité  | Séquentiel        | Asynchrone             |
| Scalabilité | Limitee par appel | Forte grâce à la queue |

---

## 📅 Kafka : principes fondamentaux

![Kafka principles] (images/Kafka schema.gif)

Apache Kafka est une plateforme de streaming d'événements distribuée. Elle repose sur un modèle **pub/sub** avec les éléments suivants :

* **Producteurs** : envoient des messages vers un **topic**
* **Topics** : unité logique qui regroupe les messages
* **Brokers** : serveurs qui stockent et distribuent les messages
* **Consumers** : abonnés qui consomment les messages
* **Consumer Groups** : ensemble de consumers qui partagent la consommation d'un topic

### ✨ Avantages

* Tolérance aux pannes (grâce à la réplication)
* Scalabilité horizontale
* Performances élevées
* Persistance des messages

### 🏛️ Use cases

![Top 5 Kafka Uses Cases] (images/Top 5 Kafka uses.webp)

* Monitoring d'applications
* Streaming de données IoT
* Intégration entre microservices
* ETL en temps réel

---

## 📚 Objectif du TP

Le TP consiste à :

* Déployer une instance GCP automatiquement avec **Terraform**
* Configurer cette instance pour exécuter un cluster Kafka via **Docker Compose**
* Simuler un flux de messages entre producteurs et consommateurs
* Visualiser l'état du cluster via un monitoring **Prometheus + Grafana**
* Simuler une panne et vérifier la résilience de Kafka

### 📘 Schéma d’architecture

![TP Kafka deployment architecture] (images/kafka-cluster-running.png)

## 🛠️ Déroulement du TP

### 🔁 1. Lancement du pipeline GitHub Actions

Le pipeline est déclenché via GitHub Actions (workflow\_dispatch).

#### 🔹 Étapes :

* **Terraform Apply** : déploie une instance GCP Debian
* **Configuration VM** : mise à jour, installation de git et git clone du projet
* **Provisioning** : installation de Java, Docker, Docker Compose
* **Exécution** :

  * Lancement du cluster Kafka (3 brokers)
  * HAProxy pour distribuer les requêtes
  * Prometheus + Grafana pour le monitoring

### 🔦 2. Envoi et consommation de messages

* 3 producteurs envoient des messages
* 3 topics sont créés
* 3 consumer groups consomment :

  * Group 1: 1 consumer
  * Group 2: 2 consumers
  * Group 3: 3 consumers

### ❄️ 3. Simulation de panne

* Un broker Kafka est stoppé manuellement
* Le monitoring Grafana indique l'état du cluster (2/3 brokers actifs)
* La consommation des messages continue sans erreur : preuve de résilience

---

## 🎭 Illustrations (ajouter les images/gif)

### ✅ Kafka running on GCP

![Kafka Cluster Running](images/kafka-cluster-running.png)

### ✅ Grafana Dashboard

![Grafana Monitoring](images/grafana-dashboard.png)

### ❌ Simulated Broker Failure

![Kafka Broker Down](images/broker-down.gif)

### ✅ Message Flow

![Message Flow](images/message-flow.gif)

---

## 🎉 Conclusion

Vous avez :

* Déployé un cluster Kafka automatiquement avec Terraform
* Mis en place une architecture event-driven
* Observé le comportement en cas de panne
* Monitoré l'activité grâce à Prometheus + Grafana

### ✨ Prolongements possibles :

* Ajouter Kafka Connect pour intégration de base de données
* Utiliser Kafka Streams pour le traitement temps réel
* Déployer sur Kubernetes
* Intégrer avec un SI existant

---

Merci pour votre participation à cette formation Kafka ✨
