locals {
  kv_name                      = var.imported_legacy.enabled ? var.imported_legacy.appKeyvaultName : format("%s-kv", var.resource_name_prefix)
  cdn_service_principal_obj_id = "c00305a0-ff5f-4059-a95a-5155bf9963ad"
  kv_config_name               = format("%s-kv-config", var.resource_name_prefix)
}

resource "azurerm_key_vault" "kv" {
  name                     = local.kv_name
  location                 = var.location
  resource_group_name      = azurerm_resource_group.main.name
  sku_name                 = "standard"
  tenant_id                = var.ARM_TENANT_ID_LEGACY
  tags                     = var.tags
  purge_protection_enabled = true

  access_policy = [
    {
      tenant_id      = var.ARM_TENANT_ID_LEGACY
      object_id      = var.aad_app_id_legacy
      application_id = null

      key_permissions = [
        "Get",
        "List",
        "Create",
        "Backup",
        "Restore",
        "UnwrapKey",
        "WrapKey",
        "Delete"
      ]

      secret_permissions = [
        "Set",
        "Get",
        "List",
        "Delete"
      ]

      certificate_permissions = [
        "Get",
        "List"
      ]

      storage_permissions = []
    },
    {
      tenant_id      = var.ARM_TENANT_ID_LEGACY
      object_id      = var.aad_deployment_id_legacy
      application_id = null

      key_permissions = []

      secret_permissions = [
        "Set",
        "Get",
        "List",
        "Delete"
      ]

      certificate_permissions = [
        "Get",
        "Create",
        "Import",
        "Update",
        "List"
      ]

      storage_permissions = []
    },
    {
      tenant_id      = var.ARM_TENANT_ID_LEGACY
      object_id      = local.cdn_service_principal_obj_id
      application_id = null

      key_permissions = []

      secret_permissions = [
        "Get"
      ]

      certificate_permissions = [
        "Get",
        "List"
      ]

      storage_permissions = []
    },
    {
      tenant_id      = var.ARM_TENANT_ID_LEGACY
      object_id      = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
      application_id = null

      key_permissions = []

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

      storage_permissions = []
    },
    {
      tenant_id      = var.ARM_TENANT_ID_LEGACY
      object_id      = var.ask_cloud_copy_workload_identity_object_id
      application_id = null

      key_permissions = [
        "Get",
        "List",
        "Create",
        "Delete",
        "Backup",
        "Restore",
        "UnwrapKey",
        "WrapKey",
      ]

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

      storage_permissions = []
    }
  ]
}

resource "azurerm_key_vault" "kv_config" {
  name                     = local.kv_config_name
  location                 = var.location
  resource_group_name      = azurerm_resource_group.main.name
  sku_name                 = "standard"
  tenant_id                = var.ARM_TENANT_ID_LEGACY
  tags                     = var.tags
  purge_protection_enabled = true

  lifecycle {
    ignore_changes = [soft_delete_retention_days]
  }

  access_policy = [
    {
      tenant_id      = var.ARM_TENANT_ID_LEGACY
      object_id      = var.aad_app_id_legacy
      application_id = null

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
        "List"
      ]

      storage_permissions = []
    },
    {
      tenant_id      = var.ARM_TENANT_ID_LEGACY
      object_id      = var.aad_deployment_id_legacy
      application_id = null

      key_permissions = [
        "Get",
        "Create",
        "Import",
        "Update",
        "List",
        "Delete",
        "GetRotationPolicy",
        "SetRotationPolicy"
      ]

      secret_permissions = [
        "Set",
        "Get",
        "List",
        "Delete",
        "Purge"
      ]

      certificate_permissions = [
        "Get",
        "Create",
        "Import",
        "Update",
        "List",
        "Delete"
      ]

      storage_permissions = []
    },
    {
      tenant_id      = var.ARM_TENANT_ID_LEGACY
      object_id      = local.cdn_service_principal_obj_id
      application_id = null

      key_permissions = []

      secret_permissions = [
        "Get"
      ]

      certificate_permissions = [
        "Get",
        "List"
      ]

      storage_permissions = []
    },
    {
      tenant_id      = var.ARM_TENANT_ID_LEGACY
      object_id      = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
      application_id = null

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
        "List"
      ]

      storage_permissions = []
    },
    {
      tenant_id      = var.ARM_TENANT_ID_LEGACY
      object_id      = var.aad_group_contributor_with_lock
      application_id = null

      key_permissions = [
        "List",
      ]

      secret_permissions = [
        "List"
      ]

      certificate_permissions = [
        "List"
      ]

      storage_permissions = []
    }
  ]
}

resource "azurerm_key_vault_secret" "admin_app_client_assertion_certificate_password" {
  key_vault_id    = azurerm_key_vault.kv_config.id
  name            = "admin-app-client-assertion-certificate-password"
  value           = var.admin_app_client_assertion_certificate_password
  content_type    = "password"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "teamsbotmodule_actiontokensecret" {
  name            = "TeamsBotModule--ActionTokenSecret"
  value           = var.teamsbotmodule_actiontokensecret
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "secret"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "teamsbotmodule_bot1_apppassword" {
  name            = "TeamsBotModule--Bot--BotConfigs--Bot1--AppPassword"
  value           = var.teamsbotmodule_bot_apppassword
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "password"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "sa_accountkey" {
  name            = "Azure--Storage--AccountKey"
  value           = azurerm_storage_account.sa.primary_access_key
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "key"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "mongodb_connectionstring" {
  name            = "MongoDb--ConnectionString"
  value           = var.mongodb_connectionstring
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "connection-string"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "mongodb_akka_connectionstring" {
  name            = "MongoDb--AkkaConnectionString"
  value           = var.mongodb_akka_connectionstring
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "connection-string"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "mongodb_analytics_connectionstring" {
  name            = "MongoDb--AnalyticsConnectionString"
  value           = var.mongodb_analytics_connectionstring
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "connection-string"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "eventstore_appuser_password" {
  name            = "EventStore--AppUser--Password"
  value           = var.eventstore_appuser_password
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "password"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "eventstore_opsuser_password" {
  name            = "EventStore--OpsUser--Password"
  value           = var.eventstore_opsuser_password
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "password"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "security_dataencryption_key" {
  name            = "Security--DataEncryptionKey"
  value           = var.security_data_encryption_key
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "key"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "mandrill_api_key" {
  name            = "AlmModule--Mandrill--ApiKey"
  value           = var.mandrill_api_key
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "api-key"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "aad_admin_app_group_id" {
  name            = "Azure--AadAdminApp--AdminGroup"
  value           = var.aad_admin_app_group_id
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "id"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "alm_notification_token_secret" {
  name            = "AlmModule--Notification--TokenSecret"
  value           = var.almmodule_notification_token_secret
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "secret"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "almmodule_groups_security_token_secret" {
  name            = "AlmModule--Groups--Security--TokenSecret"
  value           = var.almmodule_groups_security_token_secret
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "secret"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "analyticsmodule_azure_storage_accountname" {
  name            = "AnalyticsModule--Azure--Storage--AccountName"
  value           = var.analyticsmodule_azure_storage_accountname
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "name"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "analyticsmodule_azure_storage_sastoken" {
  name            = "AnalyticsModule--Azure--Storage--SasToken"
  value           = var.analyticsmodule_azure_storage_sastoken
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "token"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "licensingmodule_chargebee_apikey" {
  name            = "LicensingModule--Chargebee--ApiKey"
  value           = var.licensingmodule_chargebee_apikey
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "api-key"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "search_key" {
  name            = "ArchiveModule--Index--SearchServices--0--ApiKey"
  value           = azurerm_search_service.search.primary_key
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "key"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "licensingmodule_licensemanager_apikey" {
  name            = "LicensingModule--LicenseManager--ApiKey"
  value           = var.licensingmodule_licensemanager_apikey
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "api-key"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "appmetrics_datadog_api_key" {
  name            = "AppMetrics--Datadog--ApiKey"
  value           = var.datadog_api_key
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "api-key"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "provisioning_api_gateway_fusion_auth_client_secret" {
  name            = "ProvisioningApiGateway--FusionAuthClient--ClientSecret"
  value           = var.provisioning_api_gateway_fusion_auth_client_secret
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "secret"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "cloud_copy_api_fusion_auth_client_secret" {
  name            = "CloudCopyApi--FusionAuthClient--ClientSecret"
  value           = var.cloud_copy_api_fusion_auth_client_secret
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "secret"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_secret" "monolith_fusion_auth_client_secret" {
  name            = "Security--ClientCredentials--ClientSecret"
  value           = var.monolith_fusion_auth_client_secret
  key_vault_id    = azurerm_key_vault.kv_config.id
  content_type    = "secret"
  expiration_date = var.kv_config_secrets_expiration_date
}

resource "azurerm_key_vault_certificate" "client_assertion_certificate_config" {
  name         = "client-assertion-certificate"
  key_vault_id = azurerm_key_vault.kv_config.id

  certificate {
    contents = filebase64(format("./assets/%s", var.client_assertion_certificate_name))
    password = var.client_assertion_certificate_pwd
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

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_key_vault_certificate" "eventstore_ca" {
  count = var.create_eventstore_ca_certificate ? 1 : 0

  name         = "eventstore-ca-2"
  key_vault_id = azurerm_key_vault.kv_config.id

  certificate {
    contents = filebase64(format("./assets/%s", var.eventstore_ca_certificate_name))
    password = var.eventstore_ca_certificate_pwd
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
  name            = "msal-data-protection-encryption"
  key_vault_id    = var.imported_legacy.enabled ? azurerm_key_vault.kv_config_legacy[0].id : azurerm_key_vault.kv_config.id
  key_type        = "RSA"
  key_size        = 2048
  expiration_date = var.kv_config_keys_expiration_date

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_key_vault_key" "apikey" {
  name            = "web-key-encryption"
  key_vault_id    = azurerm_key_vault.kv_config.id
  key_type        = "RSA"
  key_size        = 2048
  expiration_date = var.kv_config_keys_expiration_date

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}
