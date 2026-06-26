#!/bin/bash
set -e

source ./env.sh

az network vnet list \
  --resource-group "$RG" \
  --query "[].name" \
  --output table

# Désassocier le NSG avant suppression
az network vnet subnet update \
  --name           "subnet-frontend" \
  --vnet-name      "$VNET_NAME" \
  --resource-group "$RG" \
  --network-security-group null

# Supprimer la NIC de test
az network nic delete \
  --name           "nic-test-${OWNER}-cli" \
  --resource-group "$RG"

# Supprimer le NSG
az network nsg delete \
  --name           "$NSG_NAME" \
  --resource-group "$RG"

# Supprimer le VNet (supprime automatiquement les subnets)
az network vnet delete \
  --name           "$VNET_NAME" \
  --resource-group "$RG"

echo "✅ Ressources réseau supprimées"

# Vérification
az network vnet list \
  --resource-group "$RG" \
  --query          "[].name" \
  --output         table