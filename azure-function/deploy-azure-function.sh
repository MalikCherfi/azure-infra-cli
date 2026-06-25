#!/bin/bash
set -e

# ─── Variables ───────────────────────────────────────────────
RESOURCE_GROUP="rg-malik-cherfi-prf2026"
LOCATION="francecentral"
APP_SERVICE_PLAN="plan-npr-prf2026"
STORAGE_ACCOUNT="stazurefunc$RANDOM"
FUNCTION_APP="func-azure-function-$RANDOM"
PYTHON_VERSION="3.14"

# ─── 1. Connexion Azure ──────────────────────────────────────
echo "🔐 Connexion Azure..."
az login --use-device-code

# ─── 2. Storage Account ─────────
echo "🗄️  Création du Storage Account..."
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS

# ─── 3. Function App ─────────────────────────────────────────
echo "⚡ Création de la Function App..."
az functionapp create \
  --name "$FUNCTION_APP" \
  --resource-group "rg-malik-cherfi-prf2026" \
  --storage-account "$STORAGE_ACCOUNT" \
  --plan "/subscriptions/5e683e0f-b00c-48d6-9769-5aaf598de8f1/resourceGroups/rg-shared-prf2026/providers/Microsoft.Web/serverfarms/plan-npr-prf2026" \
  --runtime python \
  --runtime-version "3.11" \
  --functions-version 4 \
  --os-type linux

# ─── 4. Packaging ZIP ────────────────────────────────────────
echo "📦 Packaging..."
zip -r func.zip HttpTrigger/ host.json requirements.txt

# ─── 5. Déploiement ──────────────────────────────────────────
echo "🚀 Déploiement..."
az functionapp deployment source config-zip \
  --name "$FUNCTION_APP" \
  --resource-group "$RESOURCE_GROUP" \
  --src func.zip

# ─── 6. Nettoyage ────────────────────────────────────────────
rm func.zip

# ─── 7. URL de la fonction ───────────────────────────────────
echo ""
echo "✅ Déploiement terminé !"
echo "🔗 URL : https://${FUNCTION_APP}.azurewebsites.net/api/HttpTrigger"
echo ""
echo "Test :"
sleep 20
curl -s "https://${FUNCTION_APP}.azurewebsites.net/api/HttpTrigger" | python3 -m json.tool