#!/usr/bin/env bash
set -euo pipefail

LOCATION=${LOCATION:-eastus}
RESOURCE_GROUP=${RESOURCE_GROUP:-rg-tfstate}
STORAGE_ACCOUNT=${STORAGE_ACCOUNT:-tfstate$RANDOM$RANDOM}
CONTAINER_NAME=${CONTAINER_NAME:-tfstate}

az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2

ACCOUNT_KEY=$(az storage account keys list \
  --resource-group "$RESOURCE_GROUP" \
  --account-name "$STORAGE_ACCOUNT" \
  --query '[0].value' -o tsv)

az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$ACCOUNT_KEY"

echo "Storage account: $STORAGE_ACCOUNT"
echo "Container: $CONTAINER_NAME"
