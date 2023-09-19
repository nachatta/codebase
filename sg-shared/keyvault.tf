module "key_vault_name" {
  source   = "gsoft-inc/naming/azurerm//modules/general/key_vault"
  name     = "key-vault"
  prefixes = var.resource_prefixes
}

resource "azurerm_key_vault" "shared" {
  name                        = module.key_vault_name.result
  location                    = azurerm_resource_group.shared.location
  resource_group_name         = azurerm_resource_group.shared.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "terraform_workspace_identity" {
  key_vault_id = azurerm_key_vault.shared.id
  tenant_id    = azurerm_key_vault.shared.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Purge"
  ]
}

resource "azurerm_key_vault_access_policy" "ansible_awx_identity" {
  key_vault_id = azurerm_key_vault.shared.id
  tenant_id    = azurerm_key_vault.shared.tenant_id
  object_id    = var.ansible_awx_app_object_id

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_key_vault_access_policy" "allowed_users_dev" {
  count        = length(var.keyvault_allowed_users_dev)
  key_vault_id = azurerm_key_vault.shared.id
  tenant_id    = azurerm_key_vault.shared.tenant_id
  object_id    = element(var.keyvault_allowed_users_dev, count.index)

  secret_permissions = [
    "List"
  ]

  certificate_permissions = [
    "List"
  ]
}

resource "azurerm_key_vault_access_policy" "allowed_users_sre" {
  count        = length(var.keyvault_allowed_users_sre)
  key_vault_id = azurerm_key_vault.shared.id
  tenant_id    = azurerm_key_vault.shared.tenant_id
  object_id    = element(var.keyvault_allowed_users_sre, count.index)

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete"
  ]
}

resource "azurerm_key_vault_access_policy" "k8s_secret_provider" {
  key_vault_id = azurerm_key_vault.shared.id
  tenant_id    = azurerm_key_vault.shared.tenant_id
  object_id    = azurerm_kubernetes_cluster.shared.kubelet_identity[0].object_id

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_key_vault_secret" "ssl_certificate_password" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = var.ssl_certificate_password_name
  value        = var.ssl_certificate_password
  key_vault_id = azurerm_key_vault.shared.id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "datadog_apikey" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = var.datadog_api_key_name
  value        = var.datadog_api_key_value
  key_vault_id = azurerm_key_vault.shared.id

  tags = var.tags
}

data "azurerm_key_vault" "shared_kv_infra" {
  name = "sg-shared-kv-infra"
  resource_group_name = "sharegate-shared-dns-dev"
}

resource "azurerm_key_vault_access_policy" "shared_infra_key_vault_qa_aks_access_policy" {
  key_vault_id = data.azurerm_key_vault.shared_kv_infra.id
  tenant_id    = data.azurerm_key_vault.shared_kv_infra.tenant_id
  object_id    = var.qa_aks_agentpool_client_id

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "GetIssuers",
    "ListIssuers"
  ]
}

resource "azurerm_key_vault_access_policy" "shared_infra_key_vault_staging_aks_access_policy" {
  key_vault_id = data.azurerm_key_vault.shared_kv_infra.id
  tenant_id    = data.azurerm_key_vault.shared_kv_infra.tenant_id
  object_id    = var.staging_aks_agentpool_client_id

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "GetIssuers",
    "ListIssuers"
  ]
}

resource "azurerm_key_vault_access_policy" "shared_infra_key_vault_shared_aks_access_policy" {
  key_vault_id = data.azurerm_key_vault.shared_kv_infra.id
  tenant_id    = data.azurerm_key_vault.shared_kv_infra.tenant_id
  object_id    = var.shared_aks_agentpool_client_id

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "GetIssuers",
    "ListIssuers"
  ]
}

resource "azurerm_key_vault_access_policy" "one_sg_k8s_secret_provider" {
  key_vault_id = data.azurerm_key_vault.shared_kv_infra.id
  tenant_id    = data.azurerm_key_vault.shared_kv_infra.tenant_id
  object_id    = "1aab88b1-59ea-430e-9ac5-a2c1d5a138f4"

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "GetIssuers",
    "ListIssuers"
  ]
}

resource "azurerm_key_vault_access_policy" "one_sg_stg_k8s_secret_provider" {
  key_vault_id = data.azurerm_key_vault.shared_kv_infra.id
  tenant_id    = data.azurerm_key_vault.shared_kv_infra.tenant_id
  object_id    = "8d091cb0-089b-492e-aad1-ae515d749382"

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "GetIssuers",
    "ListIssuers"
  ]
}