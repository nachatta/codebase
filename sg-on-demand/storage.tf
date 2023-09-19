module "main_storage_name" {
  source   = "gsoft-inc/naming/azurerm//modules/storage/storage_account"
  name     = "sa"
  prefixes = var.resource_prefixes
}

module "main_share_name" {
  source   = "gsoft-inc/naming/azurerm//modules/storage/file_share_name"
  name     = "fs"
  prefixes = var.resource_prefixes
}

resource "azurerm_storage_account" "main" {
  name                     = module.main_storage_name.result
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_storage_share" "main" {
  name                 = module.main_share_name.result
  storage_account_name = azurerm_storage_account.main.name
  quota                = 50
}

resource "azurerm_role_assignment" "storage_account_aks_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "qa_storage_account_azdevops_agent_blob_data_contributors" {
  scope = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

resource "azurerm_key_vault_secret" "storage_account_qa_test_access_key" {
  key_vault_id = azurerm_key_vault.config.id
  name         = "Azure--Test--Storage--AccountKey"
  value        = azurerm_storage_account.main.primary_access_key
}

resource "azurerm_storage_container" "msal_data_protection" {
  name                  = "msal-data-protection"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}