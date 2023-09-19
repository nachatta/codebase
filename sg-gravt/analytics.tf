resource "azurerm_log_analytics_workspace" "analytics_workspace" {
  name                = var.analytics_workspace_name
  location            = var.location
  resource_group_name = var.analytics_workspace_resource_group
  tags                = var.tags
  lifecycle {
    ignore_changes = [
      tags # Unable to change the current tags
    ]
  }
}
