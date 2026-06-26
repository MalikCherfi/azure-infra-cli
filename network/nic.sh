#!/bin/bash
set -e

source ./env.sh

# Create a network interface
echo "Creating network interface 'nic-test-${OWNER}-cli' in resource group '$RG'..."
az network nic create \
  --name           "nic-test-${OWNER}-cli" \
  --resource-group "$RG" \
  --location       "$LOCATION" \
  --vnet-name      "$VNET_NAME" \
  --subnet         "subnet-frontend" \
  --tags           $TAGS

# Show the network interface details
echo "Showing network interface 'nic-test-${OWNER}-cli' details..."
  az network nic list-effective-nsg \
  --name           "nic-test-${OWNER}-cli" \
  --resource-group "$RG" \
  --query          "effectiveNetworkSecurityGroups[0].effectiveSecurityRules[].{Nom:name, Priorite:priority, Direction:direction, Action:access, Port:destinationPortRanges}" \
  --output         table