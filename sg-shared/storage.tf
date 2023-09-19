module "vault_disk_name_new" {
  source   = "gsoft-inc/naming/azurerm//modules/storage/managed_disk_name"
  name     = "vault"
  prefixes = var.resource_prefixes
}

module "vault_audit_disk_name_new" {
  source   = "gsoft-inc/naming/azurerm//modules/storage/managed_disk_name"
  name     = "vault-audit"
  prefixes = var.resource_prefixes
}

resource "azurerm_managed_disk" "vault_new" {
  name                 = module.vault_disk_name_new.result
  location             = var.location
  resource_group_name  = azurerm_kubernetes_cluster.shared.node_resource_group
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 16

  tags = var.tags
}

resource "azurerm_managed_disk" "vault_audit_new" {
  name                 = module.vault_audit_disk_name_new.result
  location             = var.location
  resource_group_name  = azurerm_kubernetes_cluster.shared.node_resource_group
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 16

  tags = var.tags
}