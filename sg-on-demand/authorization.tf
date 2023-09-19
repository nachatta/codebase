resource "azurerm_role_assignment" "acrpull" {
  scope                = data.azurerm_container_registry.shared.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "acrdelete" {
  scope                = data.azurerm_container_registry.shared.id
  role_definition_name = "AcrDelete"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

resource "azurerm_role_assignment" "outbound_ip_network_contributor" {
  scope                = azurerm_public_ip_prefix.aks_outbound_prefix.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

resource "azurerm_role_assignment" "contributor_for_archives" {
  scope                = azurerm_resource_group.archives.id
  role_definition_name = "Contributor"
  principal_id         = var.azuread_application_sp_object_id
}

resource "azurerm_role_assignment" "reader_for_app_config" {
  scope                = azurerm_app_configuration.appconf.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

