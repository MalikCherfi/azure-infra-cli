#!/bin/bash
set -e

source ./env.sh

# create Bash shell variables
vnetName=$VNET_NAME
frontSubnetName=$FRONT_SUBNET_NAME
backSubnetName=$BACK_SUBNET_NAME
vnetAddressPrefix=10.0.0.0/16
frontSubnetAddressPrefix=10.0.1.0/24
backSubnetAddressPrefix=10.0.2.0/24

# Create a virtual network
echo "Creating virtual network '$vnetName' in resource group '$RG'..."
az network vnet create \
  --name $vnetName \
  --resource-group $RG \
  --address-prefixes $vnetAddressPrefix \

# Create the front-end subnet
echo "Creating front-end subnet '$frontSubnetName' in virtual network '$vnetName'..."
az network vnet subnet create \
  --name $frontSubnetName \
  --resource-group $RG \
  --vnet-name $vnetName \
  --address-prefixes $frontSubnetAddressPrefix

# Create the back-end subnet
echo "Creating back-end subnet '$backSubnetName' in virtual network '$vnetName'..."
az network vnet subnet create \
  --name $backSubnetName \
  --resource-group $RG \
  --vnet-name $vnetName \
  --address-prefixes $backSubnetAddressPrefix

# List the subnets in the virtual network
echo "Listing subnets in virtual network '$vnetName'..."
az network vnet subnet list \
  --vnet-name      "$VNET_NAME" \
  --resource-group "$RG" \
  --query          "[].{Nom:name, Plage:addressPrefix, Statut:provisioningState}" \
  --output         table

# Show the virtual network details
echo "Showing virtual network '$vnetName' details..."
az network vnet show \
  --name           "$VNET_NAME" \
  --resource-group "$RG" \
  --query          "{nom:name, adresses:addressSpace.addressPrefixes, subnets:subnets[].name}" \
  --output         json
