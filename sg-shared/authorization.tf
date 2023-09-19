resource "azurerm_role_assignment" "network_contributor" {
  scope                = azurerm_resource_group.shared.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.shared.identity[0].principal_id
}

resource "azurerm_role_assignment" "cluster_user" {
  count                = length(var.aks_aad_admin_group_object_ids)
  scope                = azurerm_resource_group.shared.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = element(var.aks_aad_admin_group_object_ids, count.index)
}

resource "azurerm_role_assignment" "cluster_admin" {
  count                = length(var.aks_aad_admin_group_object_ids)
  scope                = azurerm_resource_group.shared.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = element(var.aks_aad_admin_group_object_ids, count.index)
}

resource "azurerm_role_assignment" "dev_build_agent_contributor" {
  principal_id = var.dev_build_agent_object_id
  scope = data.azurerm_dns_zone.sharegate_dev.id
  role_definition_name = "DNS Zone Contributor"
}

resource "azurerm_role_assignment" "sharegate_dev_external_dns" {
  principal_id = var.apricot_qa_aks_pool_object_id
  scope = data.azurerm_dns_zone.sharegate_dev.id
  role_definition_name = "DNS Zone Contributor"
}

resource "azurerm_role_assignment" "acr_reader" {
  count                = length(var.acr_reader_group_object_ids)
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = element(var.acr_reader_group_object_ids, count.index)
}

resource "azurerm_role_assignment" "ci_acr_push" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id = "e7b37be9-4ef7-4236-a44b-f60cbdbcd2ad" # sharegate-gravt-dev build automation
}