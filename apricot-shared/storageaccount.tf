module "sharedstorageaccount_name" {
  source   = "gsoft-inc/naming/azurerm//modules/storage/storage_account"
  name     = "shared"
  prefixes = var.resource_prefixes
}

resource "azurerm_storage_account" "shared" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = var.location
  name                     = module.sharedstorageaccount_name.result
  resource_group_name      = data.azurerm_resource_group.apricot_shared.name
  
  tags = var.tags
}

resource "azurerm_role_assignment" "storage_account_contributors" {
  for_each = toset(var.contributor_groups)
  principal_id = each.key
  scope = azurerm_storage_account.shared.id
  role_definition_name = "Storage Table Data Contributor"
}

data "azurerm_storage_account" "qa" {
  name                = "sg0apricot0qa0sa0mal8ygv"
  resource_group_name = "apricot-qa-main-5th0xj7219s7a"
}

resource "azurerm_role_assignment" "qa_storage_account_azdevops_agent_data_contributor" {
  principal_id = var.sg_shared_cluster_principal_id
  scope = data.azurerm_storage_account.qa.id
  role_definition_name = "Storage Table Data Contributor"
}

resource "azurerm_role_assignment" "blob_storage_account_contributors" {
  for_each = toset(var.contributor_groups)
  principal_id = each.key
  scope = azurerm_storage_account.shared.id
  role_definition_name = "Storage Blob Data Contributor"
}

resource "azurerm_role_assignment" "qa_storage_account_azdevops_agent_blob_data_contributors" {
  principal_id = var.sg_shared_cluster_principal_id
  scope = data.azurerm_storage_account.qa.id
  role_definition_name = "Storage Blob Data Contributor"
}

resource "azurerm_key_vault_secret" "storage_account_test_access_key" {
  key_vault_id = data.azurerm_key_vault.shared.id
  name         = "Azure--Test--Storage--AccountKey"
  value        = azurerm_storage_account.shared.primary_access_key
}