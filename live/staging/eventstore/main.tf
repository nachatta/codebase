terraform {
  required_version = "1.4.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.58.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_subnet" "legacy_sg_gravt_stg_subnet" {
  name                 = var.legacy_sg_gravt_subnet_name
  virtual_network_name = var.legacy_sg_gravt_vnet_subnet_name
  resource_group_name  = var.esdb_rg_name
}

data "azurerm_network_security_group" "legacy_sg_gravt_stg_nsg" {
  name                = var.legacy_sg_gravt_nsg_name
  resource_group_name = var.esdb_rg_name
}

module "eventstore" {
  source = "./../../../modules/eventstore"

  sg_gravt_azurerm_subnet_main_id                 = data.azurerm_subnet.legacy_sg_gravt_stg_subnet.id
  sg_gravt_azurerm_network_security_group_main_id = data.azurerm_network_security_group.legacy_sg_gravt_stg_nsg.id
  sg_gravt_azurerm_resource_group_main_name       = var.esdb_rg_name
  sg_gravt_azurerm_private_dns_zone_main_name     = var.legacy_sg_gravt_private_dns_zone_name

  data_disk_names                              = var.data_disk_names
  esdb_rg_name                                 = var.esdb_rg_name
  location                                     = var.location
  network_interface_esdb_ip_configuration_name = var.network_interface_esdb_ip_configuration_name
  node_count                                   = var.node_count
  node_size                                    = var.node_size
  node_storage_type                            = var.node_storage_type
  private_dns_record_esdb_cluster_name         = var.private_dns_record_esdb_cluster_name
  resource_name_prefix                         = var.resource_name_prefix
  resource_prefixes                            = var.resource_prefixes
  tags                                         = var.tags
  use_resource_naming_randomness               = var.use_resource_naming_randomness
  vm_admin                                     = var.vm_admin
  vm_admin_public_key                          = var.vm_admin_public_key
}
