variable "name" {
  type        = string
  description = "Linux VM name."
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
  default     = "Standard_B1s"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the VM."
}

variable "enable_public_ip" {
  type        = bool
  description = "Whether to create a public IP."
  default     = false
}

variable "public_ip_sku" {
  type        = string
  description = "Public IP SKU."
  default     = "Standard"
}

variable "enable_identity" {
  type        = bool
  description = "Enable system-assigned managed identity."
  default     = false
}
