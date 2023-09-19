output "aks_inbound_ip" {
  value = azurerm_public_ip.aks_inbound.ip_address
}

output "aks_outbound_ips" {
  value = azurerm_public_ip_prefix.aks_outbound_prefix.ip_prefix
}

output "aks_agentpool_client_id" {
  value = azurerm_kubernetes_cluster.main.kubelet_identity[0].client_id
}

output "aks_agentpool_object_id" {
  value = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}