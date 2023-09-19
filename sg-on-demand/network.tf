module "main_virtual_network_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/virtual_network"
  name     = "main"
  prefixes = var.resource_prefixes
}

module "main_network_security_group_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/network_security_group"
  name     = "main"
  prefixes = var.resource_prefixes
}

module "main_subnet_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/subnet"
  name     = "main"
  prefixes = var.resource_prefixes
}

module "aks_subnet_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/subnet"
  name     = "aks"
  prefixes = var.resource_prefixes
}

module "pe_kv_name" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "kv"
  prefixes = concat(var.resource_prefixes,["pe"])
}

module "pe_kv_config_name" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "kvconfig"
  prefixes = concat(var.resource_prefixes,["pe"])
}

module "pe_blobstorage_name" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "blobstorage"
  prefixes = concat(var.resource_prefixes,["pe"])
}

resource "azurerm_virtual_network" "main" {
  name                = module.main_virtual_network_name.result
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

resource "azurerm_network_security_group" "main" {
  name                = module.main_network_security_group_name.result
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = concat(var.gsoft_ips, [azurerm_public_ip_prefix.aks_outbound_prefix.ip_prefix])
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_subnet" "main" {
  name                                           = module.main_subnet_name.result
  resource_group_name                            = azurerm_resource_group.main.name
  virtual_network_name                           = azurerm_virtual_network.main.name
  address_prefixes                               = ["10.0.1.0/24"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_private_dns_zone" "main" {
  name                = var.private_dns_zone_name
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

resource "azurerm_private_dns_zone" "blobstorage" {
  name                = "privatelink.blob.core.windows.net"
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

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_vnet_link" {
  name                  = "keyvault"
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  resource_group_name   = azurerm_resource_group.main.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "blobstorage_vnet_link" {
  name                  = "blobstorage"
  private_dns_zone_name = azurerm_private_dns_zone.blobstorage.name
  resource_group_name   = azurerm_resource_group.main.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = var.tags
}

resource "azurerm_private_endpoint" "kv" {
  name                = module.pe_kv_name.result
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.main.id

  private_service_connection {
    name                           = "${module.pe_kv_name.result}-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.main.id
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = azurerm_key_vault.main.name
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault.id]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "kv_config" {
  name                = module.pe_kv_config_name.result
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.main.id

  private_service_connection {
    name                           = "${module.pe_kv_config_name.result}-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.config.id
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = azurerm_key_vault.main.name
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault.id]
  }

  tags = var.tags
}


resource "azurerm_private_endpoint" "blobstorage" {
  name                = module.pe_blobstorage_name.result
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.main.id

  private_service_connection {
    name                           = "${module.pe_blobstorage_name.result}-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = azurerm_storage_account.main.name
    private_dns_zone_ids = [azurerm_private_dns_zone.blobstorage.id]
  }

  tags = var.tags
}
