variable "name" {
  type        = string
  description = "Key Vault name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID."
}

variable "use_rbac" {
  type        = bool
  description = "Enable RBAC authorization."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to Key Vault."
}

variable "create_sample_secret" {
  type        = bool
  description = "Whether to create the sample secret."
  default     = true
}

variable "sample_secret_name" {
  type        = string
  description = "Sample secret name."
  default     = "lab-sample-secret"
}

variable "sample_secret_value" {
  type        = string
  description = "Sample secret value."
  sensitive   = true
  default     = "replace-me"
}
