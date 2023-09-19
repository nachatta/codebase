output "aks_inbound_ip" {
  value = azurerm_public_ip.aks_inbound.ip_address
}

output "aks_outbound_ip" {
  value = azurerm_public_ip.aks_outbound.ip_address
}

output "aks_agentpool_client_id" {
  value = azurerm_kubernetes_cluster.shared.kubelet_identity[0].client_id
}

output "vault_disk_name" {
  value = azurerm_managed_disk.vault_new.name
}

output "vault_disk_audit_name" {
  value = azurerm_managed_disk.vault_audit_new.name
}

