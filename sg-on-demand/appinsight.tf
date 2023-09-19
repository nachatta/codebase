module "modsec_app_insights_name" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "modsec"
  prefixes = var.resource_prefixes
}

module "modsec_rg_name" {
  source   = "gsoft-inc/naming/azurerm//modules/general/resource_group"
  name     = "modsec"
  prefixes = var.resource_group_prefixes
}

resource "azurerm_resource_group" "modsec" {
  location = "canadacentral"
  name = module.modsec_rg_name.result
  tags = var.tags
}

resource "azurerm_application_insights" "modsec" {
  application_type = "other"
  location = "canadacentral"
  name = module.modsec_app_insights_name.result
  resource_group_name = azurerm_resource_group.modsec.name
  daily_data_cap_in_gb = 5
  tags = var.tags
}