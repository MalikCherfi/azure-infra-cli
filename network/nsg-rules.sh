#!/bin/bash
set -e

source ./env.sh

# Create security rules
echo "Creating security rule 'Allow-HTTP' in network security group '$NSG_NAME'..."
az network nsg rule create \
    --name "Allow-HTTP" \
    --nsg-name $NSG_NAME \
    --priority 100 \
    --resource-group $RG \
    --destination-port-ranges 80 \
    --access Allow \
    --direction Inbound \

echo "Creating security rule 'Allow-HTTPS' in network security group '$NSG_NAME'..."
az network nsg rule create \
    --name "Allow-HTTPS" \
    --nsg-name $NSG_NAME \
    --priority 110 \
    --resource-group $RG \
    --destination-port-ranges 443 \
    --access Allow \
    --direction Inbound \

echo "Creating security rule 'Deny-All-Inbound' in network security group '$NSG_NAME'..."
az network nsg rule create \
    --name "Deny-All-Inbound" \
    --nsg-name $NSG_NAME \
    --priority 4000 \
    --resource-group $RG \
    --destination-port-ranges "*" \
    --access Deny \
    --direction Inbound \

# Show the security rules
echo "Listing security rules in network security group '$NSG_NAME'..."
az network nsg rule list \
  --nsg-name       "$NSG_NAME" \
  --resource-group "$RG" \
  --query          "[].{Nom:name, Priorite:priority, Direction:direction, Action:access, Port:destinationPortRange}" \
  --output         table

# Update the network security group
echo "Updating network security group '$NSG_NAME'..."
az network vnet subnet update \
  --name $FRONT_SUBNET_NAME \
  --vnet-name $VNET_NAME \
  --resource-group $RG \
  --network-security-group $NSG_NAME

# Show the network security group
echo "Listing subnets in virtual network '$VNET_NAME'..."
az network vnet subnet show \
  --name           "subnet-frontend" \
  --vnet-name      "$VNET_NAME" \
  --resource-group "$RG" \
  --query          "{Subnet:name, NSG:networkSecurityGroup.id}" \
  --output         json