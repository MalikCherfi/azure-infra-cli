#!/bin/bash
set -e

# ─── Variables ───────────────────────────────────────────────
RESOURCE_GROUP="rg-malik-cherfi-prf2026"
APP_NAME="api-appservice-malik"

# ─── 1. Suppression de la Web App ────────────────────────────
echo "🗑️  Suppression de la Web App..."
az webapp delete \
  --name "$APP_NAME" \
  --resource-group "$RESOURCE_GROUP"

echo "✅ Web App $APP_NAME supprimée"