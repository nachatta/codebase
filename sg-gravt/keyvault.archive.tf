resource "azurerm_key_vault_secret" "archive_app_account_name" {
  key_vault_id    = azurerm_key_vault.kv_config.id
  name            = "ArchiveModule--Vaults--AppStorageAccount--AccountName"
  value           = azurerm_storage_account.sa.name
  content_type    = "name"
  expiration_date = var.kv_config_secrets_expiration_date
}

# TODO: Only  use for email which should use managed identity instead
resource "azurerm_key_vault_secret" "archive_app_account_key" {
  key_vault_id    = azurerm_key_vault.kv_config.id
  name            = "ArchiveModule--Vaults--AppStorageAccount--AccountKey"
  value           = azurerm_storage_account.sa.primary_access_key
  content_type    = "key"
  expiration_date = var.kv_config_secrets_expiration_date
}

# TODO: Not use anymore in Gravt (validate with Cloud Copy)
resource "azurerm_key_vault_secret" "archive_diag_account_name" {
  key_vault_id    = azurerm_key_vault.kv_config.id
  name            = "ArchiveModule--Vaults--DiagnosticStorageAccount--AccountName"
  value           = azurerm_storage_account.sa.name
  content_type    = "name"
  expiration_date = var.kv_config_secrets_expiration_date
}

# TODO: Not use anymore in Gravt (validate with Cloud Copy)
resource "azurerm_key_vault_secret" "archive_diag_account_key" {
  key_vault_id    = azurerm_key_vault.kv_config.id
  name            = "ArchiveModule--Vaults--DiagnosticStorageAccount--AccountKey"
  value           = azurerm_storage_account.sa.primary_access_key
  content_type    = "key"
  expiration_date = var.kv_config_secrets_expiration_date
}
