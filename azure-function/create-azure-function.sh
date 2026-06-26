#!/bin/bash
set -e

# ─── Variables ───────────────────────────────────────────────
RESOURCE_GROUP="rg-malik-cherfi-prf2026"
LOCATION="francecentral"
STORAGE_ACCOUNT="stazurefunc$RANDOM"
FUNCTION_APP="api-func-malik"

# ─── 1. Storage Account ──────────────────────────────────────
echo "🗄️  Création du Storage Account..."
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS

# ─── 2. Function App ─────────────────────────────────────────
echo "⚡ Création de la Function App..."
az functionapp create \
  --name "$FUNCTION_APP" \
  --resource-group "$RESOURCE_GROUP" \
  --storage-account "$STORAGE_ACCOUNT" \
  --plan "/subscriptions/5e683e0f-b00c-48d6-9769-5aaf598de8f1/resourceGroups/rg-shared-prf2026/providers/Microsoft.Web/serverfarms/plan-npr-prf2026" \
  --runtime python \
  --runtime-version "3.11" \
  --functions-version 4 \
  --os-type linux

# ─── 3. Désactiver le remote build ───────────────────────────
az functionapp config appsettings set \
  --name "$FUNCTION_APP" \
  --resource-group "$RESOURCE_GROUP" \
  --settings SCM_DO_BUILD_DURING_DEPLOYMENT=false

# ─── 4. Installation des dépendances ─────────────────────────
echo "📦 Installation des dépendances..."
pip install -r azure-function/requirements.txt \
  --target=".python_packages/lib/site-packages"

# ─── 5. Packaging ZIP (v2) ───────────────────────────────────
echo "📦 Packaging..."
cd azure-function && zip -r ../func.zip function_app.py host.json requirements.txt ../.python_packages/
cd ..

# ─── 6. Déploiement ──────────────────────────────────────────
echo "🚀 Déploiement..."
az functionapp deployment source config-zip \
  --name "$FUNCTION_APP" \
  --resource-group "$RESOURCE_GROUP" \
  --src func.zip

# ─── 7. Nettoyage ────────────────────────────────────────────
rm func.zip

# ─── 8. URL de la fonction ───────────────────────────────────
echo ""
echo "✅ Déploiement terminé !"
echo "🔗 URL : https://${FUNCTION_APP}.azurewebsites.net/api/hello"
echo ""
echo "Test :"
sleep 20
curl -s "https://${FUNCTION_APP}.azurewebsites.net/api/hello" | python3 -m json.tool