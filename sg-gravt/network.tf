# TODO: Validate if it's used or can be deleted.
resource "azurerm_private_dns_zone" "shared" {
  name                = var.shared_private_dns_zone
  resource_group_name = azurerm_virtual_network.main.resource_group_name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "shared_private_zone" {
  name                  = "shared"
  private_dns_zone_name = azurerm_private_dns_zone.shared.name
  resource_group_name   = azurerm_virtual_network.main.resource_group_name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = var.tags
}

resource "azurerm_virtual_network" "main" {
  name                = format("%s-vnet", var.resource_name_prefix)
  address_space       = var.main_vnet_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

resource "azurerm_subnet" "main" {
  name                                      = format("%s-subnet", var.resource_name_prefix)
  resource_group_name                       = azurerm_resource_group.main.name
  virtual_network_name                      = azurerm_virtual_network.main.name
  address_prefixes                          = var.main_subnet_address_prefixes
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_private_dns_zone" "main" {
  name                = format("gravt.%s", var.workspace)
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = azurerm_virtual_network.main.name
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = var.tags
}

# TODO: Validate if can be moved to Event Store worspace
resource "azurerm_network_security_group" "main" {
  name                = format("%s-nsg", var.resource_name_prefix)
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

resource "azurerm_private_dns_zone" "keyvault" {
  count = var.use_private_endpoint ? 1 : 0

  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_vnet_link" {
  count = var.use_private_endpoint ? 1 : 0

  name                  = "keyvault"
  private_dns_zone_name = azurerm_private_dns_zone.keyvault[0].name
  resource_group_name   = azurerm_resource_group.main.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = var.tags
}

resource "azurerm_private_dns_zone" "sqlserver" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "sqlserver_vnet_link" {
  name                  = "sqlserver"
  private_dns_zone_name = azurerm_private_dns_zone.sqlserver.name
  resource_group_name   = azurerm_resource_group.main.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = var.tags
}

resource "azurerm_private_dns_zone" "blobstorage" {
  count = var.use_private_endpoint ? 1 : 0

  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "blobstorage_vnet_link" {
  count = var.use_private_endpoint ? 1 : 0

  name                  = "blobstorage"
  private_dns_zone_name = azurerm_private_dns_zone.blobstorage[0].name
  resource_group_name   = azurerm_resource_group.main.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = var.tags
}

resource "azurerm_private_endpoint" "kv" {
  count = var.use_private_endpoint ? 1 : 0

  name                = local.private_endpoint_kv
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.main.id

  private_service_connection {
    name                           = "${local.private_endpoint_kv}-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = azurerm_key_vault.kv.name
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault[0].id]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "kv_config" {
  count = var.use_private_endpoint ? 1 : 0

  name                = local.private_endpoint_kvconfig
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.main.id

  private_service_connection {
    name                           = "${local.private_endpoint_kvconfig}-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.kv_config.id
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = azurerm_key_vault.kv_config.name
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault[0].id]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "sqlserver" {
  name                = local.private_endpoint_sqlserver
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.main.id

  private_service_connection {
    name                           = "${local.private_endpoint_sqlserver}-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = azurerm_mssql_server.sql_server.name
    private_dns_zone_ids = [azurerm_private_dns_zone.sqlserver.id]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "blobstorage" {
  count = var.use_private_endpoint ? 1 : 0

  name                = local.private_endpoint_blobstorage
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.main.id

  private_service_connection {
    name                           = format("%s-connection", local.private_endpoint_blobstorage)
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.sa.id
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = azurerm_storage_account.sa.name
    private_dns_zone_ids = [azurerm_private_dns_zone.blobstorage[0].id]
  }

  tags = var.tags
}