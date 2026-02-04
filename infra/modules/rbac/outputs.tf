output "cloud_admin_assignment_id" {
  value       = azurerm_role_assignment.cloud_admins_owner.id
  description = "Cloud Admins Owner role assignment ID."
}
