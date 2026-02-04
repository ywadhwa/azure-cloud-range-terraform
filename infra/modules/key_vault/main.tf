resource "azurerm_key_vault" "this" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  enable_rbac_authorization  = var.use_rbac
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  tags                       = var.tags
}

resource "azurerm_key_vault_secret" "sample" {
  count        = var.create_sample_secret ? 1 : 0
  name         = var.sample_secret_name
  value        = var.sample_secret_value
  key_vault_id = azurerm_key_vault.this.id
}
