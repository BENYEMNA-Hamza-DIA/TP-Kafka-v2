#!/bin/bash

echo "📥 [INFO] Récupération des messages consommés..."

LOGS_FOUND=false

for file in consumer_*.log; do
    if [[ -s "$file" ]]; then
        LOGS_FOUND=true
        echo "🔍 [$file] Messages consommés :"
        cat "$file"
        echo "---------------------------------"
    fi
done

if [ "$LOGS_FOUND" = false ]; then
    echo "⚠️ [INFO] Aucun message consommé détecté."
fi
