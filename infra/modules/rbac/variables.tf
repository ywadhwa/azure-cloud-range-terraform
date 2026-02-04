variable "subscription_id" {
  type        = string
  description = "Subscription ID."
}

variable "cloud_admin_group_id" {
  type        = string
  description = "Cloud-Admins group object ID."
}

variable "app_operators_group_id" {
  type        = string
  description = "App-Operators group object ID."
}

variable "readers_group_id" {
  type        = string
  description = "Readers group object ID."
}

variable "prod_rg_id" {
  type        = string
  description = "Prod RG ID."
}

variable "nonprod_rg_id" {
  type        = string
  description = "Nonprod RG ID."
}

variable "all_rg_ids" {
  type        = list(string)
  description = "List of all RG IDs for Readers assignment."
}
