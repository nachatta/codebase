data_disk_names = [
  "sggravtprodesnode0tg1nw6t3nwa2-datadisk-000-20220318-1200",
  "sggravtprodesnode12fad1qjm3neb-datadisk-000-20220405-120156",
  "sggravtprodesnode243pq8bmy2nc1-datadisk-000-20220405-120156"
]

esdb_rg_name = "gravt-prod-es"

location = "East US 2"

network_interface_esdb_ip_configuration_name = "esdb-node-ip"

node_count        = 3
node_size         = "Standard_D16as_v4"
node_storage_type = "Premium_LRS"

private_dns_record_esdb_cluster_name = "esdb-cluster"

resource_name_prefix = "sg-gravt-prod"
resource_prefixes = [
  "sg",
  "gravt",
  "prod",
  "esdb"
]

tags = {
  "environment" = "production"
  "owner"       = "yohan.belval@gsoft.com"
  "costCenter"  = "apricot"
  "department"  = "sharegate"
}

use_resource_naming_randomness = true

vm_admin = "vm_admin"
