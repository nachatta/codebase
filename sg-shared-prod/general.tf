module "resource_group_name" {
  source  = "gsoft-inc/naming/azurerm//modules/general/resource_group"
  version = "0.5.0"

  name     = "shared"
  prefixes = var.resource_prefixes
}

resource "azurerm_resource_group" "shared_prod" {
  location = var.location
  name     = module.resource_group_name.result
  tags     = var.tags
}
