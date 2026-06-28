#!/bin/bash
set -e

RESOURCE_GROUP="rg-malik-cherfi-prf2026"
CONTAINER_NAME="api-aci-malik-php"
ACR_NAME="acrmalikphp"

# ─── 1. Supprimer le conteneur ───────────────────────────────
echo "🗑️ Suppression du conteneur $CONTAINER_NAME..."
az container delete \
  --name "$CONTAINER_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --yes

# ─── 2. Supprimer l'ACR ──────────────────────────────────────
echo "🗑️ Suppression de l'ACR $ACR_NAME..."
az acr delete \
  --name "$ACR_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --yes

echo "✅ Ressources PHP supprimées"