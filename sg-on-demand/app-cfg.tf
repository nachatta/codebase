locals {
  app_config_sub_location = "canadacentral"
}

module "app_config_naming" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "config"
  prefixes = var.resource_prefixes
}

resource "azurerm_app_configuration" "appconf" {
  name                = module.app_config_naming.result
  resource_group_name = azurerm_resource_group.main.name
  location            = local.app_config_sub_location
  sku                 = "standard"
  tags                = var.tags  
}
