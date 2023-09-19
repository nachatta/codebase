variable "data_disk_names" {
  type = list(string)
}

variable "esdb_rg_name" {
  type = string
}

variable "legacy_sg_gravt_nsg_name" {
  type        = string
  description = "Required to support the isolated eventstore resources on staging; Cannot be imported from sg-gravt state"
}

variable "legacy_sg_gravt_private_dns_zone_name" {
  type        = string
  description = "Required to support the isolated eventstore resources on staging; Cannot be imported from sg-gravt state"
}

variable "legacy_sg_gravt_subnet_name" {
  type        = string
  description = "Required to support the isolated eventstore resources on staging; Cannot be imported from sg-gravt state"
}

variable "legacy_sg_gravt_vnet_subnet_name" {
  type        = string
  description = "Required to support the isolated eventstore resources on staging; Cannot be imported from sg-gravt state"
}

variable "location" {
  type = string
}

variable "network_interface_esdb_ip_configuration_name" {
  type = string
}

variable "node_count" {
  type = number
}

variable "node_size" {
  type = string
}

variable "node_storage_type" {
  type = string
}

variable "private_dns_record_esdb_cluster_name" {
  type = string
}

variable "resource_name_prefix" {
  type = string
}

variable "resource_prefixes" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "use_resource_naming_randomness" {
  type = bool
}

variable "vm_admin" {
  type = string
}

variable "vm_admin_public_key" {
  type      = string
  sensitive = true
}
