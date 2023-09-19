locals {
  esdb_recovery_vault_name_base  = "recovery-vault"
  esdb_recovery_policy_name_base = "recovery-policy"
  esdb_resource_name_prefix      = format("%s-esdb", var.resource_name_prefix)
  sg_gravt_nsg_name              = format("%s-nsg", var.resource_name_prefix)
}
