module "key_vault_name" {
  source  = "gsoft-inc/naming/azurerm//modules/general/key_vault"
  version = "0.5.0"

  name     = "key-vault"
  prefixes = var.resource_prefixes
}

resource "azurerm_key_vault" "shared" {
  location                 = var.location
  name                     = module.key_vault_name.result
  resource_group_name      = azurerm_resource_group.shared_prod.name
  sku_name                 = "standard"
  tenant_id                = data.azurerm_client_config.current.tenant_id
  tags                     = var.tags
  purge_protection_enabled = true
}

resource "azurerm_key_vault_access_policy" "cert_readers" {
  key_vault_id = azurerm_key_vault.shared.id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  for_each  = toset(var.cert_readers_object_ids)
  object_id = each.key

  certificate_permissions = [
    "Get",
    "List",
    "GetIssuers",
    "ListIssuers"
  ]

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_monitor_diagnostic_setting" "kv_sentinel_audit" {
  name                       = "kv_sentinel-audit"
  target_resource_id         = azurerm_key_vault.shared.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.sentinel.id

  enabled_log {
    category = "AuditEvent"
    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false
  }
}
