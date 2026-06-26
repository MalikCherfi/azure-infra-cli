#!/bin/bash

export OWNER="malik-cherfi"
export RG="rg-${OWNER}-prf2026"
export LOCATION="francecentral"

# Tags appliqués à toutes les ressources (cleanup du vendredi)
export TAGS="managed_by=cli environment=tp owner=${OWNER}"

# Noms des ressources réseau
export VNET_NAME="vnet-${OWNER}-cli"
export NSG_NAME="nsg-frontend-${OWNER}-cli"
export FRONT_SUBNET_NAME="subnet-frontend"
export BACK_SUBNET_NAME="subnet-backend"
export VNET_ADDRESS_PREFIX="10.0.0.0/16"
export FRONT_SUBNET_ADDRESS_PREFIX="10.0.1.0/24"
export BACK_SUBNET_ADDRESS_PREFIX="10.0.2.0/24"