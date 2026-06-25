#!/bin/bash
set -e

RESOURCE_GROUP="rg-malik-cherfi-prf2026"
LOCATION="francecentral"
CONTAINER_NAME="aci-malik-$RANDOM"
DNS_LABEL="aci-malik-php"
ACR_NAME="acrmalik$RANDOM"

# ─── 1. Connexion ────────────────────────────────────────────
az login --use-device-code

# ─── 2. Créer le Container Registry ─────────────────────────
az acr create \
  --name "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --sku Basic \
  --admin-enabled true

# ─── 3. Builder et pusher l'image directement sur ACR ────────
az acr build \
  --registry "$ACR_NAME" \
  --image "api-php:latest" \
  .

# ─── 4. Récupérer les credentials ACR ────────────────────────
ACR_SERVER="${ACR_NAME}.azurecr.io"
ACR_USERNAME=$(az acr credential show --name "$ACR_NAME" --query username --output tsv)
ACR_PASSWORD=$(az acr credential show --name "$ACR_NAME" --query passwords[0].value --output tsv)

# ─── 5. Déployer le conteneur avec ton image ─────────────────
az container create \
  --name "$CONTAINER_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --image "${ACR_SERVER}/api-php:latest" \
  --registry-login-server "$ACR_SERVER" \
  --registry-username "$ACR_USERNAME" \
  --registry-password "$ACR_PASSWORD" \
  --cpu 1 \
  --memory 1.5 \
  --ports 80 \
  --protocol TCP \
  --ip-address public \
  --dns-name-label "$DNS_LABEL" \
  --os-type Linux

# ─── 6. URL ──────────────────────────────────────────────────
echo "✅ Déployé sur : http://${DNS_LABEL}.${LOCATION}.azurecontainer.io"