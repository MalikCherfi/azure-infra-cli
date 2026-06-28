#!/bin/bash
set -e

RESOURCE_GROUP="rg-malik-cherfi-prf2026"
LOCATION="francecentral"
CONTAINER_NAME="aci-$RANDOM"
DNS_LABEL="aci-malik"
IMAGE="mcr.microsoft.com/azuredocs/aci-helloworld"

# ─── 1. Déploiement du conteneur ─────────────────────────────
az container create \
  --name "$CONTAINER_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --image "$IMAGE" \
  --cpu 1 \
  --memory 1.5 \
  --ports 80 \
  --protocol TCP \
  --ip-address public \
  --dns-name-label "$DNS_LABEL" \
  --os-type Linux

# ─── 2. Récupérer l'URL ──────────────────────────────────────
FQDN=$(az container show \
  --name "$CONTAINER_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "ipAddress.fqdn" \
  --output tsv)

echo "✅ Conteneur déployé !"
echo "🔗 URL : http://${FQDN}"

# ─── 3. Vérifier les logs ────────────────────────────────────
az container logs \
  --name "$CONTAINER_NAME" \
  --resource-group "$RESOURCE_GROUP"