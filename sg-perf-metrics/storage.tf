module "mssql_server_name" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "sql"
  prefixes = var.resource_prefixes
}

module "mssql_db_name" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "db"
  prefixes = var.resource_prefixes
}

module "storage_account_name" {
  source   = "gsoft-inc/naming/azurerm//modules/storage/storage_account"
  name     = "sa"
  prefixes = var.resource_prefixes
}


resource "azurerm_mssql_server" "main" {
  name                         = module.mssql_server_name.result
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = "dbadmin"
  administrator_login_password = var.bi_db_admin_password

  tags                         = var.tags
}

resource "azurerm_mssql_database" "main" {
  name           = module.mssql_db_name.result
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 2
  sku_name       = "Basic"

  tags           = var.tags
}

resource "azurerm_storage_account" "main" {
  name                     = module.storage_account_name.result
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags                     = var.tags
}