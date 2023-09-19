data "azurerm_client_config" "current" {}

data "azurerm_container_registry" "shared" {
  name                = var.shared_container_registry_name
  resource_group_name = var.shared_container_registry_resource_group_name
}
