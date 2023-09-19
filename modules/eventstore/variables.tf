variable "data_disk_names" {
  type = list(string)
}

variable "esdb_rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "network_interface_esdb_ip_configuration_name" {
  type        = string
  description = "Required to support staging naming"
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
  type        = string
  description = "Required to support staging naming"
}

variable "resource_name_prefix" {
  type = string
}

variable "resource_prefixes" {
  type = list(string)
}

variable "sg_gravt_azurerm_subnet_main_id" {
  type        = string
  description = "Should be imported from the sg-gravt state for the matching environment"
}

variable "sg_gravt_azurerm_network_security_group_main_id" {
  type        = string
  description = "Should be imported from the sg-gravt state for the matching environment"
}

variable "sg_gravt_azurerm_resource_group_main_name" {
  type        = string
  description = "Should be imported from the sg-gravt state for the matching environment"
}

variable "sg_gravt_azurerm_private_dns_zone_main_name" {
  type        = string
  description = "Should be imported from the sg-gravt state for the matching environment"
}

variable "tags" {
  type = map(string)
}

variable "use_resource_naming_randomness" {
  type        = bool
  description = "Enables the usage of the naming module that adds a random string after the resource name; Required to support staging naming"
}

variable "vm_admin" {
  type = string
}

variable "vm_admin_public_key" {
  type      = string
  sensitive = true
}

variable "gsoft_ips" {
  type = list(string)
  default = [
    "52.139.90.40/32"    #zscaler
  ]
}
