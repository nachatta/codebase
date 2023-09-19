resource "azurerm_monitor_diagnostic_setting" "kv_sentinel_audit" {
  name                       = "kv_sentinel-audit"
  target_resource_id         = data.terraform_remote_state.sg_gravt_prod.outputs.kv_id
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

resource "azurerm_monitor_diagnostic_setting" "kv_config_sentinel_audit" {
  name                       = "kv-config_sentinel-audit"
  target_resource_id         = data.terraform_remote_state.sg_gravt_prod.outputs.kv_config_id
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
