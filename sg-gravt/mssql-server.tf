module "sql_server_name" {
  source  = "gsoft-inc/naming/azurerm"
  version = "0.5.0"

  name     = "sql-server"
  prefixes = var.resource_prefixes
}

module "sql_database_name" {
  source  = "gsoft-inc/naming/azurerm"
  version = "0.5.0"

  name     = "msal-cache"
  prefixes = var.resource_prefixes
}

resource "azurerm_mssql_server" "sql_server" {
  name                = var.imported_legacy.enabled ? var.imported_legacy.sqlServerName : module.sql_server_name.result
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  version             = "12.0"
  minimum_tls_version = "1.2"

  azuread_administrator {
    azuread_authentication_only = true
    login_username              = var.msal_cache_sql_server_admin_username
    object_id                   = var.msal_cache_sql_server_admin_objectid
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags # Unable to change the current tags
    ]
  }
}

resource "azurerm_mssql_database" "msal_cache" {
  name                 = var.imported_legacy.enabled ? var.imported_legacy.sqlDatabaseName : module.sql_database_name.result
  server_id            = azurerm_mssql_server.sql_server.id
  collation            = var.msal_cache_sql_collation
  max_size_gb          = var.msal_cache_sql_size_gb
  read_scale           = false
  sku_name             = var.msal_cache_sql_sku_name
  zone_redundant       = false
  storage_account_type = var.msal_cache_sql_storage_account_type
  tags                 = var.tags

  lifecycle {
    ignore_changes = [
      tags # Unable to change the current tags
    ]
  }
}

resource "azurerm_key_vault_secret" "sql_cache" {
  key_vault_id = azurerm_key_vault.kv_config.id
  name         = "Msal--SqlCache--SqlServerConnectionString"
  value = format(
    "Server=tcp:%s,1433;Initial Catalog=%s;Persist Security Info=False;User ID=%s;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Authentication=Active Directory Managed Identity",
    azurerm_mssql_server.sql_server.fully_qualified_domain_name,
    azurerm_mssql_database.msal_cache.name,
  azurerm_kubernetes_cluster.cluster.kubelet_identity[0].client_id)
  content_type    = "connection-string"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_mssql_server_extended_auditing_policy" "sql_server_auditing_setttings" {
  server_id              = azurerm_mssql_server.sql_server.id
  log_monitoring_enabled = true
}

# master database cannot be created and need to be a data block
data "azurerm_mssql_database" "master" {
  name      = "master"
  server_id = azurerm_mssql_server.sql_server.id
}

resource "azurerm_mssql_database_extended_auditing_policy" "master_db_auditing_settings" {
  database_id            = data.azurerm_mssql_database.master.id
  log_monitoring_enabled = true
}

resource "azurerm_monitor_diagnostic_setting" "master_db_security_audit_events" {
  name                       = "security-audit-events"
  target_resource_id         = data.azurerm_mssql_database.master.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.analytics_workspace.id

  enabled_log {
    category = "SQLSecurityAuditEvents"
  }

  metric {
    category = "Basic"
    enabled  = false
  }

  metric {
    category = "InstanceAndAppAdvanced"
    enabled  = false
  }

  metric {
    category = "WorkloadManagement"
    enabled  = false
  }
}

resource "azurerm_mssql_database_extended_auditing_policy" "sql_msal_cache_db_auditing_settings" {
  database_id            = azurerm_mssql_database.msal_cache.id
  log_monitoring_enabled = true
}

resource "azurerm_monitor_diagnostic_setting" "sql_msal_cache_security_audit_events" {
  name                       = "security-audit-events"
  target_resource_id         = azurerm_mssql_database.msal_cache.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.analytics_workspace.id

  enabled_log {
    category = "SQLSecurityAuditEvents"
  }

  metric {
    category = "Basic"
    enabled  = false
  }

  metric {
    category = "InstanceAndAppAdvanced"
    enabled  = false
  }

  metric {
    category = "WorkloadManagement"
    enabled  = false
  }
}
