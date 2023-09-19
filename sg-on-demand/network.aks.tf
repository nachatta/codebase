module "aks_load_balancer_public_outbound_ip_prefix_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/public_ip_address"
  name     = "outbound"
  prefixes = concat(var.resource_prefixes, ["aks"])
}

module "aks_load_balancer_public_inbound_ip_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/public_ip_address"
  name     = "inbound"
  prefixes = concat(var.resource_prefixes, ["aks"])
}

module "aks_virtual_network_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/virtual_network"
  name     = "aks"
  prefixes = var.resource_prefixes
}

resource "azurerm_subnet" "aks" {
  name                                           = module.aks_virtual_network_name.result
  resource_group_name                            = azurerm_resource_group.main.name
  virtual_network_name                           = azurerm_virtual_network.main.name
  address_prefixes                               = ["10.0.16.0/20"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_public_ip_prefix" "aks_outbound_prefix" {
  location = azurerm_resource_group.main.location
  name = module.aks_load_balancer_public_outbound_ip_prefix_name.result
  resource_group_name = module.main_aks_node_pool_name.result
  sku = "Standard"
 
  prefix_length = 31
  
  tags = var.tags
}

resource "azurerm_public_ip" "aks_inbound" {
  name                = module.aks_load_balancer_public_inbound_ip_name.result
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  availability_zone = "No-Zone"

  tags = var.tags
}