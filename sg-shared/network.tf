module "virtual_network_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/virtual_network"
  name     = "shared"
  prefixes = var.resource_prefixes
}

module "network_security_group_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/network_security_group"
  name     = "shared"
  prefixes = var.resource_prefixes
}

module "network_interface_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/network_interface"
  name     = "shared"
  prefixes = var.resource_prefixes
}

module "subnet_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/subnet"
  name     = "shared"
  prefixes = var.resource_prefixes
}

module "aks_load_balancer_public_outbound_ip_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/public_ip_address"
  name     = "outbound"
  prefixes = concat(var.resource_prefixes, ["aks"])
}

module "aks_load_balancer_public_inbound_ip_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/public_ip_address"
  name     = "inbound"
  prefixes = concat(var.resource_prefixes, ["aks"])
}

resource "azurerm_virtual_network" "shared" {
  name                = module.virtual_network_name.result
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name

  tags = var.tags
}

resource "azurerm_network_security_group" "shared" {
  name                = module.network_security_group_name.result
  location            = var.location
  resource_group_name = azurerm_resource_group.shared.name

  tags = var.tags
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = var.gsoft_ips
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.shared.name
  network_security_group_name = azurerm_network_security_group.shared.name
}

resource "azurerm_subnet" "shared" {
  name                                           = module.subnet_name.result
  resource_group_name                            = azurerm_resource_group.shared.name
  virtual_network_name                           = azurerm_virtual_network.shared.name
  address_prefixes                               = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "aks_outbound" {
  name                = module.aks_load_balancer_public_outbound_ip_name.result
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1","2","3"]
  tags = var.tags
}

resource "azurerm_public_ip" "aks_inbound" {
  name                = module.aks_load_balancer_public_inbound_ip_name.result
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1","2","3"]
  tags = var.tags
}

data "azurerm_dns_zone" "sharegate_dev" {
  name = "sharegate-dev.com"
  resource_group_name = "sharegate-shared-dns-dev"
}

resource "azurerm_dns_a_record" "api" {
  count = length(var.staging_api_dns_record_names)
  name = element(var.staging_api_dns_record_names, count.index)
  zone_name = data.azurerm_dns_zone.sharegate_dev.name
  resource_group_name = data.azurerm_dns_zone.sharegate_dev.resource_group_name
  ttl = 60
  target_resource_id = var.staging_app_aks_id_private
}

resource "azurerm_dns_a_record" "admin_api" {
  count = length(var.staging_admin_api_dns_record_names)
  name = element(var.staging_admin_api_dns_record_names, count.index)
  zone_name = data.azurerm_dns_zone.sharegate_dev.name
  resource_group_name = data.azurerm_dns_zone.sharegate_dev.resource_group_name
  ttl = 60
  target_resource_id = var.staging_app_aks_id_private
}

resource "azurerm_dns_a_record" "webapp" {
  count = length(var.staging_webapp_dns_record_names)
  name = element(var.staging_webapp_dns_record_names, count.index)
  zone_name = data.azurerm_dns_zone.sharegate_dev.name
  resource_group_name = data.azurerm_dns_zone.sharegate_dev.resource_group_name
  ttl = 60
  target_resource_id = var.staging_app_aks_id_private
}

resource "azurerm_dns_a_record" "admin_webapp" {
  count = length(var.staging_admin_webapp_dns_record_names)
  name = element(var.staging_admin_webapp_dns_record_names, count.index)
  zone_name = data.azurerm_dns_zone.sharegate_dev.name
  resource_group_name = data.azurerm_dns_zone.sharegate_dev.resource_group_name
  ttl = 60
  target_resource_id = var.staging_app_aks_id_private
}

resource "azurerm_dns_a_record" "demoapp" {
  count = length(var.staging_demoapp_dns_record_names)
  name = element(var.staging_demoapp_dns_record_names, count.index)
  zone_name = data.azurerm_dns_zone.sharegate_dev.name
  resource_group_name = data.azurerm_dns_zone.sharegate_dev.resource_group_name
  ttl = 60
  target_resource_id = var.staging_app_aks_id_private
}

resource "azurerm_dns_a_record" "teams" {
  count = length(var.staging_teams_dns_record_names)
  name = element(var.staging_teams_dns_record_names, count.index)
  zone_name = data.azurerm_dns_zone.sharegate_dev.name
  resource_group_name = data.azurerm_dns_zone.sharegate_dev.resource_group_name
  ttl = 60
  target_resource_id = var.staging_app_aks_id_public
}

resource "azurerm_dns_a_record" "help" {
  count = length(var.staging_help_dns_record_names)
  name = element(var.staging_help_dns_record_names, count.index)
  zone_name = data.azurerm_dns_zone.sharegate_dev.name
  resource_group_name = data.azurerm_dns_zone.sharegate_dev.resource_group_name
  ttl = 60
  target_resource_id = var.staging_app_aks_id_embedded
}

resource "azurerm_dns_a_record" "vault" {
  name = "vault"
  zone_name = data.azurerm_dns_zone.sharegate_dev.name
  resource_group_name = data.azurerm_dns_zone.sharegate_dev.resource_group_name
  ttl = 60
  target_resource_id = var.shared_app_aks_id
}

resource "azurerm_dns_a_record" "awx" {
  name = "awx"
  zone_name = data.azurerm_dns_zone.sharegate_dev.name
  resource_group_name = data.azurerm_dns_zone.sharegate_dev.resource_group_name
  ttl = 60
  target_resource_id = var.shared_app_aks_id
}

resource "azurerm_dns_a_record" "es" {
  count = length(var.staging_es_dns_record_names)
  name = element(var.staging_es_dns_record_names, count.index)
  zone_name = data.azurerm_dns_zone.sharegate_dev.name
  resource_group_name = data.azurerm_dns_zone.sharegate_dev.resource_group_name
  ttl = 60
  target_resource_id = var.staging_app_aks_id_private
}