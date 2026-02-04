variable "location" {
  type        = string
  description = "Azure region for all resources."
  default     = "eastus"
}

variable "project" {
  type        = string
  description = "Project tag value."
}

variable "owner" {
  type        = string
  description = "Owner tag value."
}

variable "environment" {
  type        = string
  description = "Environment tag value."
  default     = "lab"
}

variable "ttl_hours" {
  type        = number
  description = "TTL hours tag value."
  default     = 24
}

variable "enable_jumpbox_public_ip" {
  type        = bool
  description = "Enable public IP on the jumpbox."
  default     = false
}

variable "admin_public_ip_cidr" {
  type        = string
  description = "Admin public IP CIDR allowed to SSH to jumpbox when enabled."
  default     = "0.0.0.0/32"
}

variable "enable_log_analytics" {
  type        = bool
  description = "Enable Log Analytics workspace and diagnostics."
  default     = false
}

variable "windows_vm_size" {
  type        = string
  description = "Windows VM size."
  default     = "Standard_B2s"
}

variable "kv_use_rbac" {
  type        = bool
  description = "Use RBAC authorization for Key Vault."
  default     = true
}

variable "tenant_domain" {
  type        = string
  description = "Primary tenant domain (e.g., contoso.onmicrosoft.com)."
}

variable "alice_password" {
  type        = string
  description = "Password for alice.admin."
  sensitive   = true
}

variable "bob_password" {
  type        = string
  description = "Password for bob.dev."
  sensitive   = true
}

variable "charlie_password" {
  type        = string
  description = "Password for charlie.ops."
  sensitive   = true
}

variable "linux_admin_username" {
  type        = string
  description = "Admin username for Linux VMs."
  default     = "azureuser"
}

variable "linux_admin_password" {
  type        = string
  description = "Admin password for Linux VMs."
  sensitive   = true
}

variable "windows_admin_username" {
  type        = string
  description = "Admin username for Windows VM."
  default     = "azureadmin"
}

variable "windows_admin_password" {
  type        = string
  description = "Admin password for Windows VM."
  sensitive   = true
}

variable "jumpbox_admin_username" {
  type        = string
  description = "Admin username for jumpbox VM."
  default     = "jumpadmin"
}

variable "jumpbox_admin_password" {
  type        = string
  description = "Admin password for jumpbox VM."
  sensitive   = true
}

variable "sample_secret_value" {
  type        = string
  description = "Sample secret value stored in Key Vault."
  sensitive   = true
}

variable "app_display_name" {
  type        = string
  description = "App registration display name."
  default     = "baseline-lab-app"
}

variable "key_vault_name" {
  type        = string
  description = "Optional Key Vault name override (must be globally unique)."
  default     = null
}
