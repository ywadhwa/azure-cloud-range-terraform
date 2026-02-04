variable "name" {
  type        = string
  description = "NSG name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "subnet_id" {
  type        = string
  description = "Optional subnet ID to associate."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the NSG."
}

variable "rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "List of NSG rules."
}
