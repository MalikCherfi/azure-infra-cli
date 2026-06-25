#!/bin/bash
set -e

# ─── Variables ───────────────────────────────────────────────
RESOURCE_GROUP="rg-malik-cherfi-prf2026"
LOCATION="francecentral"
APP_NAME="app-web-php-$RANDOM"
APP_SERVICE_PLAN="plan-npr-prf2026"
PHP_VERSION="8.2"
SKU="B1"                          

# ─── 1. Connexion Azure ──────────────────────────────────────
echo "🔐 Connexion Azure..."
az login --use-device-code

# ─── 4. Web App PHP ──────────────────────────────────────────
echo "🌐 Création de la Web App..."
az webapp create \
  --name "$APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --plan "$APP_SERVICE_PLAN" \
  --runtime "PHP|$PHP_VERSION"


# ─── 6. ZIP et déploiement ───────────────────────────────────
echo "📦 Packaging et déploiement..."
zip app.zip index.php

az webapp deploy \
  --name "$APP_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --src-path ./app.zip \
  --type zip

rm app.zip


# ─── 8. URL de l'application ─────────────────────────────────
APP_URL="https://${APP_NAME}.azurewebsites.net"
echo ""
echo "✅ Déploiement terminé !"
echo "🔗 URL : $APP_URL"
echo ""
echo "Test de l'API :"
sleep 15
curl -s "$APP_URL" | python3 -m json.tool