variable "name" {
  type        = string
  description = "Hub VNet name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the hub VNet."
}

variable "address_space" {
  type        = list(string)
  description = "Hub VNet address space."
}

variable "subnets" {
  type        = map(string)
  description = "Map of subnet names to address prefixes."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to hub networking resources."
}
