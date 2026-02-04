output "vnet_id" {
  value       = azurerm_virtual_network.spoke.id
  description = "Spoke VNet ID."
}

output "vnet_name" {
  value       = azurerm_virtual_network.spoke.name
  description = "Spoke VNet name."
}

output "subnet_id" {
  value       = azurerm_subnet.spoke.id
  description = "Spoke subnet ID."
}
