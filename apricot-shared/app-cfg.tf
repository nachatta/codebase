module "app_config_naming" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "config"
  prefixes = var.resource_prefixes
}

resource "azurerm_app_configuration" "appconf" {
  name                = module.app_config_naming.result
  resource_group_name = data.azurerm_resource_group.apricot_shared.name
  location            = var.app_config_sub_location
  sku                 = "standard"
  
  tags = var.tags
}

resource "azurerm_role_assignment" "appconf" {
  scope = azurerm_app_configuration.appconf.id
  role_definition_name = "App Configuration Data Reader"
  for_each = toset(var.contributor_groups)
  principal_id = each.key
}