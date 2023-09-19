module "servicebus_name" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "servicebus"
  prefixes = var.resource_prefixes
}

resource "azurerm_servicebus_namespace" "main" {
  name = module.servicebus_name.result
  location = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku = "Standard"
  
  tags = var.tags
}

resource "azurerm_key_vault_secret" "service_bus" {
  key_vault_id = azurerm_key_vault.config.id
  name = "Azure--ServiceBus--ConnectionString"
  value = azurerm_servicebus_namespace.main.default_primary_connection_string
  depends_on = [azurerm_key_vault_access_policy.terraform_workspace_identity]
}

resource "azurerm_role_assignment" "service_bus_aks_contributor" {
  scope                = azurerm_servicebus_namespace.main.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}