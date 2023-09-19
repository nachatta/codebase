### Managing legacy config keyvault to keep MSAL Key (only)  ###
resource "azurerm_key_vault" "kv_config_legacy" {
  count               = var.imported_legacy.enabled ? 1 : 0
  name                = var.imported_legacy.msalKeyvaultName
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "standard"
  tenant_id           = var.ARM_TENANT_ID_LEGACY
  tags                = var.tags

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
        "GetRotationPolicy"
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


### Peering networks to connect to Event Store ###

data "azurerm_virtual_network" "es_network" {
  count               = var.imported_legacy.enabled ? 1 : 0
  name                = var.imported_legacy.eventStoreVirtualNetworkName
  resource_group_name = var.imported_legacy.eventStoreResourceGroup
}

resource "azurerm_virtual_network_peering" "peering_with_es_network" {
  count                     = var.imported_legacy.enabled ? 1 : 0
  name                      = format("%s-peering", data.azurerm_virtual_network.es_network[0].name)
  resource_group_name       = var.rg_main_name
  virtual_network_name      = azurerm_virtual_network.main.name
  remote_virtual_network_id = data.azurerm_virtual_network.es_network[0].id
}

# If we don't put peering both way it doesn't work
resource "azurerm_virtual_network_peering" "peering_with_es_network_reverse" {
  count                     = var.imported_legacy.enabled ? 1 : 0
  name                      = format("%s-peering", azurerm_virtual_network.main.name)
  resource_group_name       = var.imported_legacy.eventStoreResourceGroup
  virtual_network_name      = data.azurerm_virtual_network.es_network[0].name
  remote_virtual_network_id = azurerm_virtual_network.main.id
}
