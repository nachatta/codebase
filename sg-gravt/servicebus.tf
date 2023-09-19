module "servicebus_name" {
  source  = "gsoft-inc/naming/azurerm"
  version = "0.5.0"

  name     = "servicebus"
  prefixes = var.resource_prefixes
}

resource "azurerm_servicebus_namespace" "main" {
  name                = module.servicebus_name.result
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_key_vault_secret" "service_bus" {
  key_vault_id    = azurerm_key_vault.kv_config.id
  name            = "Azure--ServiceBus--ConnectionString"
  value           = azurerm_servicebus_namespace.main.default_primary_connection_string
  content_type    = "connection-string"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_monitor_diagnostic_setting" "service_bus_audit_diagnostic" {
  name                       = "audit-diagnostic"
  target_resource_id         = azurerm_servicebus_namespace.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.analytics_workspace.id

  enabled_log {
    category_group = "audit"
    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false
  }
}
