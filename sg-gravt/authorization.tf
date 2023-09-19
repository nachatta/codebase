resource "azurerm_role_assignment" "cluster_role_admin_role" {
  principal_id         = var.gravt_cluster_admin_group
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  scope                = azurerm_kubernetes_cluster.cluster.id
}

resource "azurerm_role_assignment" "cluster_role_admin_user_role" {
  principal_id         = var.gravt_cluster_admin_group
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  scope                = azurerm_kubernetes_cluster.cluster.id
}

resource "azurerm_role_assignment" "cluster_role_user_role_groups" {
  for_each             = toset(var.gravt_cluster_user_groups)
  principal_id         = each.key
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  scope                = azurerm_kubernetes_cluster.cluster.id
}

resource "azurerm_role_assignment" "cluster_identity_subnet_network_contributor" {
  principal_id         = azurerm_kubernetes_cluster.cluster.identity[0].principal_id
  role_definition_name = "Network Contributor"
  scope                = azurerm_subnet.cluster.id
}

resource "azurerm_role_assignment" "cluster_identity_resource_group_network_contributor" {
  principal_id         = azurerm_kubernetes_cluster.cluster.identity[0].principal_id
  role_definition_name = "Network Contributor"
  scope                = azurerm_resource_group.aks.id
}

resource "azurerm_role_assignment" "shared_build_agent_inbound_ip_reader" {
  principal_id         = "10f0e2c3-eaf8-418d-b833-69a6ae89e842" ## shared build agent
  role_definition_name = "Reader"
  scope                = azurerm_public_ip.cluster_inbound.id
}

resource "azurerm_role_assignment" "reader_for_app_config" {
  scope                = azurerm_app_configuration.appconf.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "shared_build_agent_inbound_private_ip_reader" {
  principal_id         = "10f0e2c3-eaf8-418d-b833-69a6ae89e842" ## shared build agent
  role_definition_name = "Reader"
  scope                = azurerm_public_ip.cluster_private_inbound.id
}
