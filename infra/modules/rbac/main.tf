resource "azurerm_role_assignment" "cloud_admins_owner" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = var.cloud_admin_group_id
}

resource "azurerm_role_assignment" "app_ops_prod" {
  scope                = var.prod_rg_id
  role_definition_name = "Contributor"
  principal_id         = var.app_operators_group_id
}

resource "azurerm_role_assignment" "app_ops_nonprod" {
  scope                = var.nonprod_rg_id
  role_definition_name = "Contributor"
  principal_id         = var.app_operators_group_id
}

resource "azurerm_role_assignment" "readers" {
  for_each             = toset(var.all_rg_ids)
  scope                = each.value
  role_definition_name = "Reader"
  principal_id         = var.readers_group_id
}
