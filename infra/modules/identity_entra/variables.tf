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

variable "app_display_name" {
  type        = string
  description = "Display name for the app registration."
  default     = "baseline-lab-app"
}
