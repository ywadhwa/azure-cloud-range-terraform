output "vm_id" {
  value       = azurerm_linux_virtual_machine.this.id
  description = "VM ID."
}

output "private_ip" {
  value       = azurerm_network_interface.this.private_ip_address
  description = "Private IP address."
}

output "identity_principal_id" {
  value       = try(azurerm_linux_virtual_machine.this.identity[0].principal_id, null)
  description = "Managed identity principal ID."
}

output "public_ip" {
  value       = try(azurerm_public_ip.this[0].ip_address, null)
  description = "Public IP address if created."
}
