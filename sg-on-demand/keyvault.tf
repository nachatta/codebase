module "main_vault_name" {
  source   = "gsoft-inc/naming/azurerm//modules/general/key_vault"
  name     = "main"
  prefixes = var.resource_prefixes
}

module "config_vault_name" {
  source   = "gsoft-inc/naming/azurerm//modules/general/key_vault"
  name     = "config"
  suffixes = ["bff"]
  prefixes = var.resource_prefixes
}


resource "azurerm_key_vault" "main" {
  name                            = module.main_vault_name.result
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  enabled_for_disk_encryption     = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 7
  purge_protection_enabled        = true
  sku_name                        = "standard"
  enabled_for_template_deployment = true
  

  //  network_acls {
  //    bypass = "AzureServices"
  //    default_action = "Deny"
  //    ip_rules = var.gsoft_ips
  //  }

  tags = var.tags
}

resource "azurerm_key_vault" "config" {
  name                        = module.config_vault_name.result
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  sku_name                    = "standard"

  //  network_acls {
  //    bypass = "AzureServices"
  //    default_action = "Deny"
  //    ip_rules = var.gsoft_ips
  //  }

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "terraform_workspace_identity" {
  key_vault_id = azurerm_key_vault.config.id
  tenant_id    = azurerm_key_vault.config.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
    "Create"
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Recover",
    "Delete",
    "Purge"
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

resource "azurerm_key_vault_access_policy" "k8s_secret_provider" {
  key_vault_id = azurerm_key_vault.config.id
  tenant_id    = azurerm_key_vault.config.tenant_id
  object_id    = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List"
  ]

  key_permissions = [
    "Get",
    "List",
    "WrapKey",
    "UnwrapKey"
  ]
}

resource "azurerm_key_vault_access_policy" "application_main" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = azurerm_key_vault.main.tenant_id
  object_id    = var.azuread_application_sp_object_id

  key_permissions = [
    "WrapKey",
    "UnwrapKey"
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]
}

resource "azurerm_key_vault_access_policy" "application_main_cluster" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = azurerm_key_vault.main.tenant_id
  object_id    = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]

  certificate_permissions = [
    "Get",
    "List"
  ]

  key_permissions = [
  "Get",
  "List"
  ]
}

resource "azurerm_key_vault_access_policy" "application_config" {
  key_vault_id = azurerm_key_vault.config.id
  tenant_id    = azurerm_key_vault.config.tenant_id
  object_id    = var.azuread_application_sp_object_id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_key_vault_access_policy" "shared_aks_access_policy_kv_config" {
  key_vault_id = azurerm_key_vault.config.id
  tenant_id    = azurerm_key_vault.config.tenant_id
  object_id    = var.shared_aks_agentpool_object_id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]

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

resource "azurerm_key_vault_access_policy" "shared_aks_access_policy_kv_main" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = azurerm_key_vault.main.tenant_id
  object_id    = var.shared_aks_agentpool_object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]

  certificate_permissions = [
    "Get",
    "List"
  ]

  key_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_key_vault_certificate" "client_assertion" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = var.client_assertion_certificate_name
  key_vault_id = azurerm_key_vault.config.id

  certificate {
    contents = var.client_assertion_certificate_base64
    password = var.client_assertion_certificate_password
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }

  tags = var.tags
}

resource "azurerm_key_vault_certificate" "eventstore-ca" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = var.eventstoreca_certificate_name
  key_vault_id = azurerm_key_vault.config.id

  certificate {
    contents = var.eventstoreca_certificate_base64
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    lifetime_action {
      action {
        action_type = "EmailContacts"
      }

      trigger {
        days_before_expiry  = 0
        lifetime_percentage = 80
      }
    }
  }

  tags = var.tags
}

resource "azurerm_key_vault_key" "data_protection" {
  name         = "msal-data-protection-encryption"
  key_vault_id = azurerm_key_vault.config.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}


resource "azurerm_key_vault_secret" "client_assertion_certificate_password" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = var.client_assertion_certificate_password_name
  value        = var.client_assertion_certificate_password
  key_vault_id = azurerm_key_vault.config.id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "ssl_certificate_password" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = var.ssl_certificate_password_name
  value        = var.ssl_certificate_password
  key_vault_id = azurerm_key_vault.config.id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "storage_account_key" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = "Azure--Storage--AccountKey"
  value        = azurerm_storage_account.main.primary_access_key
  key_vault_id = azurerm_key_vault.config.id
}

resource "azurerm_key_vault_secret" "eventstore_appuser_password" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = "EventStore--AppUser--Password"
  value        = var.eventstore_appuser_password
  key_vault_id = azurerm_key_vault.config.id
}

resource "azurerm_key_vault_secret" "eventstore_opsuser_password" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = "EventStore--OpsUser--Password"
  value        = var.eventstore_opsuser_password
  key_vault_id = azurerm_key_vault.config.id
}

resource "azurerm_key_vault_secret" "security_data_encryption_key" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = "Security--DataEncryptionKey"
  value        = var.security_data_encryption_key
  key_vault_id = azurerm_key_vault.config.id
}

resource "azurerm_key_vault_secret" "search_service_key" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = "ArchiveModule--Index--SearchServices--0--ApiKey"
  value        = azurerm_search_service.search.primary_key
  key_vault_id = azurerm_key_vault.config.id
}

resource "azurerm_key_vault_secret" "chargebee_api_key" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = "LicensingModule--Chargebee--ApiKey"
  value        = var.chargebee_api_key
  key_vault_id = azurerm_key_vault.config.id
}

resource "azurerm_key_vault_secret" "licensing_manager_api_key" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = "LicensingModule--LicenseManager--ApiKey"
  value        = var.license_manager_api_key
  key_vault_id = azurerm_key_vault.config.id
}

resource "azurerm_key_vault_secret" "teams_bot1_app_password" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  name         = "TeamsBotModule--Bot--BotConfigs--Bot1--AppPassword"
  value        = var.teams_bot_app_password
  key_vault_id = azurerm_key_vault.config.id
}

resource "azurerm_key_vault_secret" "datadog_api_key" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  key_vault_id = azurerm_key_vault.config.id
  name         = "AppMetrics--Datadog--ApiKey"
  value        = var.datadog_api_key
}

resource "azurerm_key_vault_secret" "sharegate-dev-external-dns-app" {
  depends_on   = [azurerm_key_vault_access_policy.terraform_workspace_identity]
  key_vault_id = azurerm_key_vault.config.id
  name         = "sharegate-dev-external-dns-secret"
  value        = <<EOF
{
  "tenantId": "eb39acb7-fae3-4bc3-974c-b765aa1d6355",
  "subscriptionId": "2a71ff47-745b-4a86-a128-e8e969d03802",
  "resourceGroup": "sharegate-shared-dns-dev",
  "useManagedIdentityExtension": true
}
  EOF
}