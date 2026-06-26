#!/bin/bash
set -e

# ─── Variables ───────────────────────────────────────────────
RESOURCE_GROUP="rg-malik-cherfi-prf2026"
FUNCTION_APP="api-func-malik"

# ─── 1. Récupérer le storage account lié ─────────────────────
echo "🔍 Récupération du Storage Account lié..."
STORAGE_ACCOUNT=$(az functionapp config appsettings list \
  --name "$FUNCTION_APP" \
  --resource-group "$RESOURCE_GROUP" \
  --query "[?name=='AzureWebJobsStorage'].value" \
  --output tsv | sed 's/.*AccountName=\([^;]*\).*/\1/')

# ─── 2. Suppression de la Function App ───────────────────────
echo "🗑️  Suppression de la Function App..."
az functionapp delete \
  --name "$FUNCTION_APP" \
  --resource-group "$RESOURCE_GROUP"

echo "✅ Function App $FUNCTION_APP supprimée"

# ─── 3. Suppression du Storage Account ───────────────────────
if [ -n "$STORAGE_ACCOUNT" ]; then
  echo "🗑️  Suppression du Storage Account $STORAGE_ACCOUNT..."
  az storage account delete \
    --name "$STORAGE_ACCOUNT" \
    --resource-group "$RESOURCE_GROUP" \
    --yes
  echo "✅ Storage Account $STORAGE_ACCOUNT supprimé"
else
  echo "⚠️  Storage Account non trouvé, suppression ignorée"
fi