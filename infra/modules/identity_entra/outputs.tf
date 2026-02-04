output "tenant_id" {
  value       = data.azuread_client_config.current.tenant_id
  description = "Tenant ID."
}

output "app_id" {
  value       = azuread_application.app.application_id
  description = "Application (client) ID."
}

output "app_object_id" {
  value       = azuread_application.app.object_id
  description = "Application object ID."
}

output "service_principal_object_id" {
  value       = azuread_service_principal.app.object_id
  description = "Service principal object ID."
}

output "app_secret_value" {
  value       = azuread_application_password.app.value
  description = "App client secret value (store in Key Vault)."
  sensitive   = true
}

output "group_ids" {
  value = {
    cloud_admins  = azuread_group.cloud_admins.object_id
    app_operators = azuread_group.app_operators.object_id
    readers       = azuread_group.readers.object_id
  }
  description = "Map of group object IDs."
}
