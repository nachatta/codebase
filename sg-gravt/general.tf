data "azurerm_subscription" "current" {}

module "main_rg_aks_name" {
  source  = "gsoft-inc/naming/azurerm//modules/general/resource_group"
  version = "0.5.0"

  name     = "aks"
  prefixes = var.resource_group_prefixes
}

resource "azurerm_resource_group" "aks" {
  location = var.location
  name     = module.main_rg_aks_name.result
  tags     = var.tags
}

resource "azurerm_resource_group" "main" {
  name     = var.rg_main_name
  location = var.location

  tags = var.tags
}