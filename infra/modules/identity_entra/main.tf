data "azuread_client_config" "current" {}

resource "azuread_user" "alice" {
  user_principal_name = "alice.admin@${var.tenant_domain}"
  display_name        = "Alice Admin"
  mail_nickname       = "alice.admin"
  password            = var.alice_password
  force_password_change = false
}

resource "azuread_user" "bob" {
  user_principal_name = "bob.dev@${var.tenant_domain}"
  display_name        = "Bob Dev"
  mail_nickname       = "bob.dev"
  password            = var.bob_password
  force_password_change = false
}

resource "azuread_user" "charlie" {
  user_principal_name = "charlie.ops@${var.tenant_domain}"
  display_name        = "Charlie Ops"
  mail_nickname       = "charlie.ops"
  password            = var.charlie_password
  force_password_change = false
}

resource "azuread_group" "cloud_admins" {
  display_name     = "Cloud-Admins"
  security_enabled = true
}

resource "azuread_group" "app_operators" {
  display_name     = "App-Operators"
  security_enabled = true
}

resource "azuread_group" "readers" {
  display_name     = "Readers"
  security_enabled = true
}

resource "azuread_group_member" "cloud_admins_alice" {
  group_object_id  = azuread_group.cloud_admins.object_id
  member_object_id = azuread_user.alice.object_id
}

resource "azuread_group_member" "app_operators_bob" {
  group_object_id  = azuread_group.app_operators.object_id
  member_object_id = azuread_user.bob.object_id
}

resource "azuread_group_member" "readers_charlie" {
  group_object_id  = azuread_group.readers.object_id
  member_object_id = azuread_user.charlie.object_id
}

resource "azuread_application" "app" {
  display_name = var.app_display_name
  owners       = [data.azuread_client_config.current.object_id]

  # Optional delegated permissions example (User.Read)
  # required_resource_access {
  #   resource_app_id = "00000003-0000-0000-c000-000000000000"
  #   resource_access {
  #     id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
  #     type = "Scope"
  #   }
  # }
}

resource "azuread_service_principal" "app" {
  application_id = azuread_application.app.application_id
}

resource "azuread_application_password" "app" {
  application_object_id = azuread_application.app.object_id
  display_name          = "lab-secret"
}
