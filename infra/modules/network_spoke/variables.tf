variable "name" {
  type        = string
  description = "Spoke VNet name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the spoke VNet."
}

variable "address_space" {
  type        = list(string)
  description = "Spoke VNet address space."
}

variable "subnet_name" {
  type        = string
  description = "Spoke subnet name."
}

variable "subnet_prefix" {
  type        = string
  description = "Spoke subnet prefix."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to spoke networking resources."
}
