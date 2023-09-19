data "azurerm_client_config" "current" {}

data "azurerm_log_analytics_workspace" "sentinel" {
  provider            = azurerm.leapsec-prod
  name                = "gsec-prod-log-sentinel"
  resource_group_name = "gsec-sentinel-prod"
}
