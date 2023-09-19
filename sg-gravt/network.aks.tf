module "cluster_load_balancer_public_outbound_ip_name" {
  source  = "gsoft-inc/naming/azurerm//modules/networking/public_ip_address"
  version = "0.5.0"

  name     = "outbound"
  prefixes = concat(var.resource_prefixes, ["cluster"])
}

module "cluster_load_balancer_public_outbound_ip_prefix_name" {
  source  = "gsoft-inc/naming/azurerm//modules/networking/public_ip_address"
  version = "0.5.0"

  name     = "outbound"
  prefixes = concat(var.resource_prefixes, ["cluster", "prefix"])
}

module "cluster_load_balancer_public_inbound_ip_name" {
  source  = "gsoft-inc/naming/azurerm//modules/networking/public_ip_address"
  version = "0.5.0"

  name     = "inbound"
  prefixes = concat(var.resource_prefixes, ["cluster"])
}

module "cluster_load_balancer_private_inbound_ip_name" {
  source  = "gsoft-inc/naming/azurerm//modules/networking/public_ip_address"
  version = "0.5.0"

  name     = "inbound"
  prefixes = concat(var.resource_prefixes, ["cluster"])
}

module "cluster_embedded-public-lb_ip_name" {
  source  = "gsoft-inc/naming/azurerm//modules/networking/public_ip_address"
  version = "0.5.0"

  name     = "embedded"
  prefixes = concat(var.resource_prefixes, ["cluster"])
}


module "cluster_subnet_name" {
  source  = "gsoft-inc/naming/azurerm//modules/networking/subnet"
  version = "0.5.0"

  name     = "cluster"
  prefixes = var.resource_prefixes
}

resource "azurerm_public_ip" "cluster_outbound" {
  name                = module.cluster_load_balancer_public_outbound_ip_name.result
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.workspace == "prod" ? ["1", "2", "3"] : []
  tags                = var.tags
}

resource "azurerm_public_ip_prefix" "cluster_outbound_prefix" {
  location            = azurerm_resource_group.aks.location
  name                = module.cluster_load_balancer_public_outbound_ip_prefix_name.result
  resource_group_name = azurerm_resource_group.aks.name
  sku                 = "Standard"
  tags                = var.tags
  zones               = var.workspace == "prod" ? ["1", "2", "3"] : []
  prefix_length       = var.cluster_outbound_prefix_length
}

resource "azurerm_public_ip" "cluster_inbound" {
  name                = module.cluster_load_balancer_public_inbound_ip_name.result
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.workspace == "prod" ? ["1", "2", "3"] : []
  tags                = var.tags
}

resource "azurerm_public_ip" "cluster_private_inbound" {
  name                = module.cluster_load_balancer_private_inbound_ip_name.result
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.workspace == "prod" ? ["1", "2", "3"] : []
  tags                = var.tags
}

resource "azurerm_subnet" "cluster" {
  name                 = module.cluster_subnet_name.result
  resource_group_name  = azurerm_virtual_network.main.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.cluster_subnet_address_prefixes
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_public_ip" "embedded-public-lb" {
  name                = module.cluster_embedded-public-lb_ip_name.result
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.workspace == "prod" ? ["1", "2", "3"] : []
  tags                = var.tags
}
