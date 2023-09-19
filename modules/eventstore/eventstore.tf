module "esdb_availability_set_name" {
  source  = "gsoft-inc/naming/azurerm"
  version = "0.5.0"

  count    = var.use_resource_naming_randomness ? 1 : 0
  name     = "aset"
  prefixes = var.resource_prefixes
}

module "esdb_virtual_machine_name" {
  source  = "gsoft-inc/naming/azurerm//modules/compute/vm_linux"
  version = "0.5.0"

  count    = var.use_resource_naming_randomness ? var.node_count : 0
  name     = "node-${count.index}"
  prefixes = var.resource_prefixes
}

module "esdb_virtual_machine_osdisk_name" {
  source  = "gsoft-inc/naming/azurerm//modules/storage/managed_disk_name"
  version = "0.5.0"

  count    = var.use_resource_naming_randomness ? var.node_count : 0
  name     = "osdisk-${count.index}"
  prefixes = var.resource_prefixes
}

module "esdb_network_interface_name" {
  source  = "gsoft-inc/naming/azurerm//modules/networking/network_interface"
  version = "0.5.0"

  count    = var.use_resource_naming_randomness ? var.node_count : 0
  name     = count.index
  prefixes = var.resource_prefixes
}

module "esdb_public_ip_name" {
  source  = "gsoft-inc/naming/azurerm//modules/networking/public_ip_address"
  version = "0.5.0"

  count    = var.use_resource_naming_randomness ? var.node_count : 0
  name     = count.index
  prefixes = var.resource_prefixes
}

resource "azurerm_resource_group" "es" {
  name     = var.esdb_rg_name
  location = var.location

  tags = var.tags
}

resource "azurerm_public_ip" "esdb" {
  count = var.node_count
  name = (
    var.use_resource_naming_randomness
    ? element(module.esdb_public_ip_name[*].result, count.index)
    : format("%s-ip-%s", local.esdb_resource_name_prefix, count.index)
  )
  location            = var.location
  resource_group_name = azurerm_resource_group.es.name
  domain_name_label = (
    var.use_resource_naming_randomness
    ? element(module.esdb_virtual_machine_name[*].result, count.index)
    : format("%s-%s", local.esdb_resource_name_prefix, count.index)
  )
  allocation_method = "Static"

  tags = var.tags
}

resource "azurerm_network_interface" "esdb" {
  count                         = var.node_count
  enable_accelerated_networking = true
  name = (
    var.use_resource_naming_randomness
    ? element(module.esdb_network_interface_name[*].result, count.index)
    : format("%s-nic-%s", local.esdb_resource_name_prefix, count.index)
  )
  location            = var.location
  resource_group_name = azurerm_resource_group.es.name

  ip_configuration {
    name                          = format("%s-%s", var.network_interface_esdb_ip_configuration_name, count.index)
    subnet_id                     = var.sg_gravt_azurerm_subnet_main_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.esdb[*].id, count.index)
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "esdb_nsg_association" {
  count                     = var.node_count
  network_interface_id      = element(azurerm_network_interface.esdb[*].id, count.index)
  network_security_group_id = var.sg_gravt_azurerm_network_security_group_main_id
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "AllowSshFromGSoftNetwork"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = var.gsoft_ips
  destination_address_prefix  = "*"
  resource_group_name         = var.sg_gravt_azurerm_resource_group_main_name
  network_security_group_name = local.sg_gravt_nsg_name
}

resource "azurerm_availability_set" "esdb" {
  name = (
    var.use_resource_naming_randomness
    ? module.esdb_availability_set_name[0].result
    : format("%s-%s", local.esdb_resource_name_prefix, "availability-set")
  )
  resource_group_name         = azurerm_resource_group.es.name
  location                    = azurerm_resource_group.es.location
  managed                     = true
  platform_fault_domain_count = 2

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "esdb" {
  count = var.node_count
  name = (
    var.use_resource_naming_randomness
    ? element(module.esdb_virtual_machine_name[*].result, count.index)
    : format("%s-%s", local.esdb_resource_name_prefix, count.index)
  )

  resource_group_name   = azurerm_resource_group.es.name
  location              = azurerm_resource_group.es.location
  availability_set_id   = azurerm_availability_set.esdb.id
  size                  = var.node_size
  admin_username        = var.vm_admin
  network_interface_ids = [element(azurerm_network_interface.esdb[*].id, count.index)]

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = var.node_storage_type
    name = (
      var.use_resource_naming_randomness
      ? element(module.esdb_virtual_machine_osdisk_name[*].result, count.index)
      : format("%s-%s-%s", local.esdb_resource_name_prefix, count.index, "osdisk")
    )
  }

  admin_ssh_key {
    username   = var.vm_admin
    public_key = var.vm_admin_public_key
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_private_dns_a_record" "esdb_cluster" {
  name                = var.private_dns_record_esdb_cluster_name
  records             = concat(azurerm_network_interface.esdb[*].private_ip_address)
  resource_group_name = var.sg_gravt_azurerm_resource_group_main_name
  ttl                 = 300
  zone_name           = var.sg_gravt_azurerm_private_dns_zone_main_name

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "esdb_aad_ssh" {
  count                      = var.node_count
  name                       = "AADSSHLoginForLinux"
  automatic_upgrade_enabled  = false
  auto_upgrade_minor_version = true
  virtual_machine_id         = element(azurerm_linux_virtual_machine.esdb[*].id, count.index)
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADSSHLoginForLinux"
  type_handler_version       = "1.0"

  tags = var.tags
}
