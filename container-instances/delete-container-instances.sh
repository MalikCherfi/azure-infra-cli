#!/bin/bash
set -e

RESOURCE_GROUP="rg-malik-cherfi-prf2026"
CONTAINER_NAME="api-aci-malik-hello"

# ─── 1. Supprimer le conteneur ───────────────────────────────
echo "🗑️ Suppression du conteneur $CONTAINER_NAME..."
az container delete \
  --name "$CONTAINER_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --yes

echo "✅ Conteneur Hello supprimé"