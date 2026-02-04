variable "name" {
  type        = string
  description = "Windows VM name."
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
  description = "Subnet ID for the VM NIC."
}

variable "admin_username" {
  type        = string
  description = "Admin username."
}

variable "admin_password" {
  type        = string
  description = "Admin password."
  sensitive   = true
}

variable "size" {
  type        = string
  description = "VM size."
  default     = "Standard_B2s"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the VM."
}
