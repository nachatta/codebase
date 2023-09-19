module "resource_group_name" {
  source   = "gsoft-inc/naming/azurerm//modules/general/resource_group"
  name     = "main"
  prefixes = var.resource_group_prefixes
}

resource "azurerm_resource_group" "shared" {
  name     = module.resource_group_name.result
  location = var.location
  tags     = var.tags
}
