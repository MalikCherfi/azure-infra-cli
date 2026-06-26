#!/bin/bash
set -e

source ./env.sh

# Create a network security group
echo "Creating network security group '$NSG_NAME' in resource group '$RG'..."
az network nsg create \
  --name $NSG_NAME \
  --resource-group $RG \
  --location $LOCATION \

# Show the default security rules
echo "Listing default security rules in network security group '$NSG_NAME'..."
az network nsg show \
  --name           "$NSG_NAME" \
  --resource-group "$RG" \
  --query          "defaultSecurityRules[].{Nom:name, Priorite:priority, Direction:direction, Action:access, Port:destinationPortRange}" \
  --output         table