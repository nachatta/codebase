resource "azurerm_key_vault_secret" "archive_app_account_name" {
  key_vault_id = azurerm_key_vault.config.id
  name         = "ArchiveModule--Vaults--AppStorageAccount--AccountName"
  value        = azurerm_storage_account.main.name
}

resource "azurerm_key_vault_secret" "archive_app_account_key" {
  key_vault_id = azurerm_key_vault.config.id
  name         = "ArchiveModule--Vaults--AppStorageAccount--AccountKey"
  value        = azurerm_storage_account.main.primary_access_key
}

resource "azurerm_key_vault_secret" "archive_diag_account_name" {
  key_vault_id = azurerm_key_vault.config.id
  name         = "ArchiveModule--Vaults--DiagnosticStorageAccount--AccountName"
  value        = azurerm_storage_account.main.name
}

resource "azurerm_key_vault_secret" "archive_diag_account_key" {
  key_vault_id = azurerm_key_vault.config.id
  name         = "ArchiveModule--Vaults--DiagnosticStorageAccount--AccountKey"
  value        = azurerm_storage_account.main.primary_access_key
}