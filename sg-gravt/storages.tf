resource "azurerm_role_assignment" "storage_account_aks_contributor" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
}

resource "azurerm_role_definition" "storage_role" {
  name        = "Apricot Storage Account Role (${var.workspace})"
  scope       = data.azurerm_subscription.current.id
  description = "Apricot Custom roles for Storage Account"

  permissions {
    actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/write",
      "Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action",
      "Microsoft.Storage/storageAccounts/tableServices/tables/read",
      "Microsoft.Storage/storageAccounts/tableServices/tables/write",
    ]
    data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/move/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action",
      "Microsoft.Storage/storageAccounts/tableServices/tables/entities/read",
      "Microsoft.Storage/storageAccounts/tableServices/tables/entities/write",
      "Microsoft.Storage/storageAccounts/tableServices/tables/entities/delete",
      "Microsoft.Storage/storageAccounts/tableServices/tables/entities/add/action",
      "Microsoft.Storage/storageAccounts/tableServices/tables/entities/update/action"
    ]
  }

  assignable_scopes = [data.azurerm_subscription.current.id]
}

resource "azurerm_role_assignment" "app_blob_role" {
  principal_id       = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
  scope              = azurerm_storage_account.sa.id
  role_definition_id = azurerm_role_definition.storage_role.role_definition_resource_id
}

resource "azurerm_storage_account" "sa" {
  name                     = var.imported_legacy.enabled ? var.imported_legacy.storageAccountName : var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 30
    }
    container_delete_retention_policy {
      days = 30
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "assets_container" {
  name                  = "assets"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "blob"
}

resource "azurerm_storage_container" "msal_data_protection" {
  name                  = "msal-data-protection"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "api_keys" {
  name                  = "apikeys"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}