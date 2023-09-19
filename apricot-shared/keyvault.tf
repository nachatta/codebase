data "azurerm_key_vault" "shared" {
  name = "sg-gravt-dev-shared"
  resource_group_name = "gravt-dev"
}

resource "azurerm_key_vault_access_policy" "terraform_workspace_identity" {
  key_vault_id = data.azurerm_key_vault.shared.id
  tenant_id = data.azurerm_key_vault.shared.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set"
  ]
}