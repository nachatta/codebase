locals {
  archive = {
    resource_group_name_archives = format("%s-archives", var.rg_main_name)
    resource_prefix              = format("%s-arch", var.resource_name_prefix)
  }
}

resource "azurerm_resource_group" "archives" {
  name     = local.archive.resource_group_name_archives
  location = var.location
  tags     = var.tags
}


resource "azurerm_search_service" "search" {
  name                = var.imported_legacy.enabled ? var.imported_legacy.archiveSearchServiceName : "${local.archive.resource_prefix}-search"
  resource_group_name = azurerm_resource_group.archives.name
  location            = var.imported_legacy.enabled ? var.imported_legacy.archiveSearchServiceLocation : var.location
  sku                 = var.archive_search_service_sku
  partition_count     = var.archive_search_service_partition_count
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags # Unable to change the current tags
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "search_service_audit_diagnostic" {
  name                       = "audit-diagnostic"
  target_resource_id         = azurerm_search_service.search.id
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
