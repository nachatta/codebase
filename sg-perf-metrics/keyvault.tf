module "key_vault_name" {
  source   = "gsoft-inc/naming/azurerm//modules/general/key_vault"
  name     = "kv"
  prefixes = var.resource_prefixes
}

resource "azurerm_key_vault" "main" {
  name                        = module.key_vault_name.result
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "terraform_workspace_identity" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = azurerm_key_vault.main.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Purge"
  ]
}

resource "azurerm_key_vault_access_policy" "allowed_principals" {
  count        = length(var.keyvault_allowed_principals)
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = azurerm_key_vault.main.tenant_id
  object_id    = element(var.keyvault_allowed_principals, count.index)

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]
}

resource "azurerm_key_vault_secret" "azdevops_access_token" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = "Azure--AzureDevOps--AccessToken"
  value        = var.azdevops_access_token
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "bi_db_connection_string" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = "Azure--BiDatabase--ConnectionString"
  value        = join(";",[
    "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433",
    "Initial Catalog=${azurerm_mssql_database.main.name}",
    "Persist Security Info=False",
    "User ID=${azurerm_mssql_server.main.administrator_login}",
    "Password=${azurerm_mssql_server.main.administrator_login_password}",
    "MultipleActiveResultSets=False",
    "Encrypt=True",
    "TrustServerCertificate=False",
    "Connection Timeout=30;"])
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "desktop_azure_release_container_url" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = "Desktop--AzureReleasesProjectOptions--AzureReleaseContainerUrl"
  value        = var.desktop_azure_release_container_url
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "desktop_mixpanel_api_secret" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = "Desktop--MixPanel--ApiSecret"
  value        = var.desktop_mixpanel_api_secret
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "jira_username" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = "Jira--Username"
  value        = var.jira_username
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "jira_password" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = "Jira--Password"
  value        = var.jira_password
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags
}