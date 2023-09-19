module "main_rg_name" {
  source   = "gsoft-inc/naming/azurerm//modules/general/resource_group"
  name     = "main"
  prefixes = var.resource_group_prefixes
}

module "archives_rg_name" {
  source   = "gsoft-inc/naming/azurerm//modules/general/resource_group"
  name     = "archives"
  prefixes = var.resource_group_prefixes
}

resource "azurerm_resource_group" "main" {
  name     = module.main_rg_name.result
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "archives" {
  name     = module.archives_rg_name.result
  location = var.location
  tags     = var.tags
}
