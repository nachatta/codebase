output "cluster_object_id" {
  value = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
}

output "cluster_client_id" {
  value = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].client_id
}

output "cluster_fqdn" {
  value = azurerm_kubernetes_cluster.cluster.fqdn
}

output "cluster_principal_id" {
  value = azurerm_kubernetes_cluster.cluster.identity[0].principal_id
}

output "cluster_outbound_ip" {
  value = azurerm_public_ip.cluster_outbound.ip_address
}

output "cluster_public_inbound_ip" {
  value = azurerm_public_ip.cluster_inbound.ip_address
}

output "cluster_private_inbound_ip" {
  value = azurerm_public_ip.cluster_private_inbound.ip_address
}

output "cluster_outbound_ip_prefix" {
  value = azurerm_public_ip_prefix.cluster_outbound_prefix.ip_prefix
}

output "cluster_subnet_id" {
  value = azurerm_subnet.cluster.id
}

output "azurerm_subnet_main_id" {
  value = azurerm_subnet.main.id
}

output "azurerm_network_security_group_main_id" {
  value = azurerm_network_security_group.main.id
}

output "azurerm_resource_group_main_name" {
  value = azurerm_resource_group.main.name
}

output "azurerm_private_dns_zone_main_name" {
  value = azurerm_private_dns_zone.main.name
}

output "kv_id" {
  value = azurerm_key_vault.kv.id
}

output "kv_config_id" {
  value = azurerm_key_vault.kv_config.id
}
