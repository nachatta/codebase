module "app_insights_name" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "ai"
  prefixes = var.resource_prefixes
}

module "func_app_service_plan_name" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "func-plan"
  prefixes = var.resource_prefixes
}

module "func_app_plan_name" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "func"
  prefixes = var.resource_prefixes
}


resource "azurerm_application_insights" "main" {
  name                = module.app_insights_name.result
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"

  tags                = var.tags
}

resource "azurerm_app_service_plan" "main" {
  name                = module.func_app_service_plan_name.result
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }

  tags                = var.tags
}

resource "azurerm_function_app" "main" {
  name                       = module.func_app_plan_name.result
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  app_service_plan_id        = azurerm_app_service_plan.main.id
  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key
  os_type                    = "linux"
  enable_builtin_logging     = false
  version                    = "~3"

  tags                       = var.tags
}
