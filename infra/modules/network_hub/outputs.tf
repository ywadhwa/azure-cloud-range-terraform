output "vnet_id" {
  value       = azurerm_virtual_network.hub.id
  description = "Hub VNet ID."
}

output "vnet_name" {
  value       = azurerm_virtual_network.hub.name
  description = "Hub VNet name."
}

output "subnet_ids" {
  value       = { for name, subnet in azurerm_subnet.hub : name => subnet.id }
  description = "Map of hub subnet IDs."
}
