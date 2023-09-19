data_disk_names = [
  "sggravtstges0-datadisk-2021-10-18-1200",
  "sggravtstges1-datadisk-2021-10-18-1200",
  "sggravtstges2-datadisk-2021-10-18-1200"
]

esdb_rg_name = "gravt-staging-es"

legacy_sg_gravt_nsg_name              = "sg-gravt-stg-nsg"
legacy_sg_gravt_private_dns_zone_name = "gravt.staging"
legacy_sg_gravt_subnet_name           = "sg-gravt-stg-subnet"
legacy_sg_gravt_vnet_subnet_name      = "sg-gravt-stg-vnet"

location = "Canada East"

network_interface_esdb_ip_configuration_name = "es-configuration"

node_count        = 3
node_size         = "Standard_D2ds_v4"
node_storage_type = "Standard_LRS"

private_dns_record_esdb_cluster_name = "es-cluster"

resource_name_prefix = "sg-gravt-stg"
resource_prefixes = [
  "sg",
  "gravt",
  "stg",
  "esdb"
]

tags = {
  "environment" = "staging"
  "owner"       = "yohan.belval@gsoft.com"
  "costCenter"  = "apricot"
  "department"  = "sharegate"
}

use_resource_naming_randomness = false

vm_admin = "vm_admin"
