#!/bin/bash
set -e

source ./env.sh

# Create a virtual network
echo "Creating virtual network '$VNET_NAME' in resource group '$RG'..."
az network vnet create \
  --name $VNET_NAME \
  --resource-group $RG \
  --address-prefixes $VNET_ADDRESS_PREFIX \

# Create the front-end subnet
echo "Creating front-end subnet '$FRONT_SUBNET_NAME' in virtual network '$VNET_NAME'..."
az network vnet subnet create \
  --name $FRONT_SUBNET_NAME \
  --resource-group $RG \
  --vnet-name $VNET_NAME \
  --address-prefixes $FRONT_SUBNET_ADDRESS_PREFIX

# Create the back-end subnet
echo "Creating back-end subnet '$BACK_SUBNET_NAME' in virtual network '$VNET_NAME'..."
az network vnet subnet create \
  --name $BACK_SUBNET_NAME \
  --resource-group $RG \
  --vnet-name $VNET_NAME \
  --address-prefixes $BACK_SUBNET_ADDRESS_PREFIX

# List the subnets in the virtual network
echo "Listing subnets in virtual network '$VNET_NAME'..."
az network vnet subnet list \
  --vnet-name      "$VNET_NAME" \
  --resource-group "$RG" \
  --query          "[].{Nom:name, Plage:addressPrefix, Statut:provisioningState}" \
  --output         table

# Show the virtual network details
echo "Showing virtual network '$VNET_NAME' details..."
az network vnet show \
  --name           "$VNET_NAME" \
  --resource-group "$RG" \
  --query          "{nom:name, adresses:addressSpace.addressPrefixes, subnets:subnets[].name}" \
  --output         json
