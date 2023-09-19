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

data "terraform_remote_state" "sg_gravt_prod" {
  backend = "remote"

  config = {
    organization = "ShareGate"
    workspaces = {
      name = "sg-gravt-prod"
    }
  }
}

module "eventstore" {
  source = "./../../../modules/eventstore"

  sg_gravt_azurerm_subnet_main_id                 = data.terraform_remote_state.sg_gravt_prod.outputs.azurerm_subnet_main_id
  sg_gravt_azurerm_network_security_group_main_id = data.terraform_remote_state.sg_gravt_prod.outputs.azurerm_network_security_group_main_id
  sg_gravt_azurerm_resource_group_main_name       = data.terraform_remote_state.sg_gravt_prod.outputs.azurerm_resource_group_main_name
  sg_gravt_azurerm_private_dns_zone_main_name     = data.terraform_remote_state.sg_gravt_prod.outputs.azurerm_private_dns_zone_main_name

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
