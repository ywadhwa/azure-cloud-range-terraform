output "vm_id" {
  value       = azurerm_windows_virtual_machine.this.id
  description = "VM ID."
}

output "private_ip" {
  value       = azurerm_network_interface.this.private_ip_address
  description = "Private IP address."
}
