module "search_service_name" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "search"
  prefixes = var.resource_prefixes
}

resource "azurerm_search_service" "search" {
  name                = module.search_service_name.result
  resource_group_name = azurerm_resource_group.main.name
  location            = var.search_service_location
  sku                 = var.search_service_sku
  tags                = var.tags
}
