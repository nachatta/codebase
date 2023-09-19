module "esdb_recovery_vault_name" {
  source  = "gsoft-inc/naming/azurerm"
  version = "0.5.0"

  count    = var.use_resource_naming_randomness ? 1 : 0
  name     = local.esdb_recovery_vault_name_base
  prefixes = var.resource_prefixes
}

module "esdb_recovery_policy_name" {
  source  = "gsoft-inc/naming/azurerm"
  version = "0.5.0"

  count    = var.use_resource_naming_randomness ? 1 : 0
  name     = local.esdb_recovery_policy_name_base
  prefixes = var.resource_prefixes
}

resource "azurerm_resource_group" "es_backup_vault" {
  name     = format("%s-backup-vault", var.esdb_rg_name)
  location = var.location
  tags     = var.tags
}

resource "azurerm_data_protection_backup_vault" "es_backup_vault" {
  name                = format("%s-es-backup-vault", var.resource_name_prefix)
  resource_group_name = azurerm_resource_group.es.name
  location            = azurerm_resource_group.es.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

resource "azurerm_role_assignment" "es_backup_vault_snapshot" {
  scope                = azurerm_resource_group.es_backup_vault.id
  role_definition_name = "Disk Snapshot Contributor"
  principal_id         = azurerm_data_protection_backup_vault.es_backup_vault.identity[0].principal_id
}

resource "azurerm_role_assignment" "es_backup_vault_restore" {
  scope                = azurerm_resource_group.es.id
  role_definition_name = "Disk Restore Operator"
  principal_id         = azurerm_data_protection_backup_vault.es_backup_vault.identity[0].principal_id
}

resource "azurerm_data_protection_backup_policy_disk" "es_backup_vault_policy" {
  name                            = "es-disk-backup-policy"
  backup_repeating_time_intervals = ["R/2021-10-12T12:00:00+00:00/PT4H"]
  default_retention_duration      = "P7D"
  vault_id                        = azurerm_data_protection_backup_vault.es_backup_vault.id
}

data "azurerm_managed_disk" "es_data_disk" {
  count               = length(var.data_disk_names)
  name                = element(var.data_disk_names, count.index)
  resource_group_name = azurerm_resource_group.es.name
}

resource "azurerm_role_assignment" "es_backup_vault_disk_reader" {
  count                = length(var.data_disk_names)
  scope                = element(data.azurerm_managed_disk.es_data_disk[*].id, count.index)
  role_definition_name = "Disk Backup Reader"
  principal_id         = azurerm_data_protection_backup_vault.es_backup_vault.identity[0].principal_id
}

resource "azurerm_data_protection_backup_instance_disk" "es_data_disk" {
  count                        = length(var.data_disk_names)
  name                         = element(var.data_disk_names, count.index)
  location                     = azurerm_data_protection_backup_vault.es_backup_vault.location
  vault_id                     = azurerm_data_protection_backup_vault.es_backup_vault.id
  disk_id                      = element(data.azurerm_managed_disk.es_data_disk[*].id, count.index)
  snapshot_resource_group_name = azurerm_resource_group.es_backup_vault.name
  backup_policy_id             = azurerm_data_protection_backup_policy_disk.es_backup_vault_policy.id
}

resource "azurerm_recovery_services_vault" "esdb_recovery_vault" {
  name = (
    var.use_resource_naming_randomness
    ? module.esdb_recovery_vault_name[0].result
    : format("%s-%s", local.esdb_resource_name_prefix, local.esdb_recovery_vault_name_base)
  )
  location            = var.location
  resource_group_name = azurerm_resource_group.es.name
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_backup_policy_vm" "esdb_recovery_policy" {
  name = (
    var.use_resource_naming_randomness
    ? module.esdb_recovery_policy_name[0].result
    : format("%s-%s", local.esdb_resource_name_prefix, local.esdb_recovery_policy_name_base)
  )
  resource_group_name = azurerm_resource_group.es.name
  recovery_vault_name = azurerm_recovery_services_vault.esdb_recovery_vault.name

  backup {
    frequency = "Daily"
    time      = "01:00"
  }

  retention_daily {
    count = 14
  }
}

resource "azurerm_backup_protected_vm" "esdb_recovery_vm" {
  count               = var.node_count
  resource_group_name = azurerm_resource_group.es.name
  recovery_vault_name = azurerm_recovery_services_vault.esdb_recovery_vault.name
  source_vm_id        = element(azurerm_linux_virtual_machine.esdb[*].id, count.index)
  backup_policy_id    = azurerm_backup_policy_vm.esdb_recovery_policy.id

  lifecycle {
    ignore_changes = [source_vm_id]
  }
}
