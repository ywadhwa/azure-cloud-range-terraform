output "tenant_id" {
  value       = module.identity.tenant_id
  description = "Tenant ID."
}

output "app_id" {
  value       = module.identity.app_id
  description = "App registration client ID."
}

output "app_object_id" {
  value       = module.identity.app_object_id
  description = "App registration object ID."
}

output "service_principal_object_id" {
  value       = module.identity.service_principal_object_id
  description = "Service principal object ID."
}

output "key_vault_name" {
  value       = module.key_vault.name
  description = "Key Vault name."
}

output "prod_linux_private_ip" {
  value       = module.prod_linux_vm.private_ip
  description = "Prod Linux VM private IP."
}

output "nonprod_linux_private_ip" {
  value       = module.nonprod_linux_vm.private_ip
  description = "Nonprod Linux VM private IP."
}

output "prod_windows_private_ip" {
  value       = module.prod_windows_vm.private_ip
  description = "Prod Windows VM private IP."
}

output "jumpbox_private_ip" {
  value       = module.jumpbox_vm.private_ip
  description = "Jumpbox private IP."
}

output "jumpbox_public_ip" {
  value       = module.jumpbox_vm.public_ip
  description = "Jumpbox public IP when enabled."
}
