data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

locals {
  tags = {
    project     = var.project
    owner       = var.owner
    environment = var.environment
    ttl_hours   = tostring(var.ttl_hours)
    scenario    = "baseline"
  }

  hub_subnets = {
    "snet-jumpbox"         = "10.0.10.0/24"
    "snet-shared-services" = "10.0.20.0/24"
  }

  prod_subnet  = "10.1.1.0/24"
  nonprod_subnet = "10.2.1.0/24"

  prod_nsg_rules = [
    {
      name                       = "allow-ssh-from-jumpbox"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = local.hub_subnets["snet-jumpbox"]
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-rdp-from-jumpbox"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = local.hub_subnets["snet-jumpbox"]
      destination_address_prefix = "*"
    },
    {
      name                       = "deny-all-inbound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]

  nonprod_nsg_rules = [
    {
      name                       = "allow-ssh-from-jumpbox"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = local.hub_subnets["snet-jumpbox"]
      destination_address_prefix = "*"
    },
    {
      name                       = "deny-all-inbound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]

  jumpbox_nsg_rules = var.enable_jumpbox_public_ip ? [
    {
      name                       = "allow-ssh-admin"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = var.admin_public_ip_cidr
      destination_address_prefix = "*"
    }
  ] : []

  key_vault_name = coalesce(var.key_vault_name, lower(replace("kv-${var.project}-${var.environment}", "_", "-")))
}

module "rg_hub_network" {
  source   = "../../modules/resource_groups"
  name     = "rg-hub-network"
  location = var.location
  tags     = local.tags
}

module "rg_prod_app" {
  source   = "../../modules/resource_groups"
  name     = "rg-prod-app"
  location = var.location
  tags     = local.tags
}

module "rg_nonprod_app" {
  source   = "../../modules/resource_groups"
  name     = "rg-nonprod-app"
  location = var.location
  tags     = local.tags
}

module "rg_shared_services" {
  source   = "../../modules/resource_groups"
  name     = "rg-shared-services"
  location = var.location
  tags     = local.tags
}

module "rg_identity" {
  source   = "../../modules/resource_groups"
  name     = "rg-identity"
  location = var.location
  tags     = local.tags
}

module "rg_logging" {
  count    = var.enable_log_analytics ? 1 : 0
  source   = "../../modules/resource_groups"
  name     = "rg-logging"
  location = var.location
  tags     = local.tags
}

module "hub_network" {
  source              = "../../modules/network_hub"
  name                = "vnet-hub"
  location            = var.location
  resource_group_name = module.rg_hub_network.name
  address_space       = ["10.0.0.0/16"]
  subnets             = local.hub_subnets
  tags                = local.tags
}

module "prod_network" {
  source              = "../../modules/network_spoke"
  name                = "vnet-prod"
  location            = var.location
  resource_group_name = module.rg_prod_app.name
  address_space       = ["10.1.0.0/16"]
  subnet_name         = "snet-prod-app"
  subnet_prefix       = local.prod_subnet
  tags                = local.tags
}

module "nonprod_network" {
  source              = "../../modules/network_spoke"
  name                = "vnet-nonprod"
  location            = var.location
  resource_group_name = module.rg_nonprod_app.name
  address_space       = ["10.2.0.0/16"]
  subnet_name         = "snet-nonprod-app"
  subnet_prefix       = local.nonprod_subnet
  tags                = local.tags
}

resource "azurerm_virtual_network_peering" "hub_to_prod" {
  name                      = "peer-hub-to-prod"
  resource_group_name       = module.rg_hub_network.name
  virtual_network_name      = module.hub_network.vnet_name
  remote_virtual_network_id = module.prod_network.vnet_id
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "prod_to_hub" {
  name                      = "peer-prod-to-hub"
  resource_group_name       = module.rg_prod_app.name
  virtual_network_name      = module.prod_network.vnet_name
  remote_virtual_network_id = module.hub_network.vnet_id
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "hub_to_nonprod" {
  name                      = "peer-hub-to-nonprod"
  resource_group_name       = module.rg_hub_network.name
  virtual_network_name      = module.hub_network.vnet_name
  remote_virtual_network_id = module.nonprod_network.vnet_id
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "nonprod_to_hub" {
  name                      = "peer-nonprod-to-hub"
  resource_group_name       = module.rg_nonprod_app.name
  virtual_network_name      = module.nonprod_network.vnet_name
  remote_virtual_network_id = module.hub_network.vnet_id
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true
}

module "nsg_prod_app" {
  source              = "../../modules/nsg"
  name                = "nsg-prod-app"
  location            = var.location
  resource_group_name = module.rg_prod_app.name
  subnet_id           = module.prod_network.subnet_id
  rules               = local.prod_nsg_rules
  tags                = local.tags
}

module "nsg_nonprod_app" {
  source              = "../../modules/nsg"
  name                = "nsg-nonprod-app"
  location            = var.location
  resource_group_name = module.rg_nonprod_app.name
  subnet_id           = module.nonprod_network.subnet_id
  rules               = local.nonprod_nsg_rules
  tags                = local.tags
}

module "nsg_jumpbox" {
  source              = "../../modules/nsg"
  name                = "nsg-jumpbox"
  location            = var.location
  resource_group_name = module.rg_hub_network.name
  subnet_id           = module.hub_network.subnet_ids["snet-jumpbox"]
  rules               = local.jumpbox_nsg_rules
  tags                = local.tags
}

module "prod_linux_vm" {
  source              = "../../modules/compute_linux_vm"
  name                = "vm-prod-linux"
  location            = var.location
  resource_group_name = module.rg_prod_app.name
  subnet_id           = module.prod_network.subnet_id
  admin_username      = var.linux_admin_username
  admin_password      = var.linux_admin_password
  size                = "Standard_B1s"
  enable_identity     = true
  tags                = local.tags
}

module "nonprod_linux_vm" {
  source              = "../../modules/compute_linux_vm"
  name                = "vm-nonprod-linux"
  location            = var.location
  resource_group_name = module.rg_nonprod_app.name
  subnet_id           = module.nonprod_network.subnet_id
  admin_username      = var.linux_admin_username
  admin_password      = var.linux_admin_password
  size                = "Standard_B1s"
  tags                = local.tags
}

module "prod_windows_vm" {
  source              = "../../modules/compute_windows_vm"
  name                = "vm-prod-windows"
  location            = var.location
  resource_group_name = module.rg_prod_app.name
  subnet_id           = module.prod_network.subnet_id
  admin_username      = var.windows_admin_username
  admin_password      = var.windows_admin_password
  size                = var.windows_vm_size
  tags                = local.tags
}

module "jumpbox_vm" {
  source              = "../../modules/compute_linux_vm"
  name                = "vm-jumpbox"
  location            = var.location
  resource_group_name = module.rg_hub_network.name
  subnet_id           = module.hub_network.subnet_ids["snet-jumpbox"]
  admin_username      = var.jumpbox_admin_username
  admin_password      = var.jumpbox_admin_password
  size                = "Standard_B1s"
  enable_public_ip    = var.enable_jumpbox_public_ip
  tags                = local.tags
}

module "key_vault" {
  source              = "../../modules/key_vault"
  name                = local.key_vault_name
  location            = var.location
  resource_group_name = module.rg_shared_services.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  use_rbac            = var.kv_use_rbac
  sample_secret_value = var.sample_secret_value
  tags                = local.tags
}

resource "azurerm_role_assignment" "kv_secrets_user" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.prod_linux_vm.identity_principal_id
}

module "identity" {
  source           = "../../modules/identity_entra"
  tenant_domain    = var.tenant_domain
  alice_password   = var.alice_password
  bob_password     = var.bob_password
  charlie_password = var.charlie_password
  app_display_name = var.app_display_name
}

resource "azurerm_key_vault_secret" "app_client_secret" {
  name         = "app-client-secret"
  value        = module.identity.app_secret_value
  key_vault_id = module.key_vault.id
}

module "rbac" {
  source                 = "../../modules/rbac"
  subscription_id        = data.azurerm_subscription.current.subscription_id
  cloud_admin_group_id   = module.identity.group_ids.cloud_admins
  app_operators_group_id = module.identity.group_ids.app_operators
  readers_group_id       = module.identity.group_ids.readers
  prod_rg_id             = module.rg_prod_app.id
  nonprod_rg_id          = module.rg_nonprod_app.id
  all_rg_ids             = compact([
    module.rg_hub_network.id,
    module.rg_prod_app.id,
    module.rg_nonprod_app.id,
    module.rg_shared_services.id,
    module.rg_identity.id,
    try(module.rg_logging[0].id, null)
  ])
}

module "logging" {
  count               = var.enable_log_analytics ? 1 : 0
  source              = "../../modules/logging_optional"
  name                = "law-baseline"
  location            = var.location
  resource_group_name = module.rg_logging[0].name
  tags                = local.tags
}

resource "azurerm_monitor_diagnostic_setting" "kv" {
  count                      = var.enable_log_analytics ? 1 : 0
  name                       = "diag-kv"
  target_resource_id         = module.key_vault.id
  log_analytics_workspace_id = module.logging[0].id

  enabled_log {
    category = "AuditEvent"
  }

  metric {
    category = "AllMetrics"
  }
}
