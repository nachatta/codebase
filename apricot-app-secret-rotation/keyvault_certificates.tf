module "kv_certificates" {
  count                                    = length(var.key_vault_app_certificates)
  source                                   = "./modules/kv-self-signed-certificate-module"
  key_vault_name                           = var.key_vault_app_certificates[count.index].key_vault_name
  key_vault_resource_group_name            = var.key_vault_app_certificates[count.index].key_vault_resource_group_name
  key_vault_certificate_name               = var.key_vault_app_certificates[count.index].key_vault_certificate_name
  key_vault_certificate_subject            = var.key_vault_app_certificates[count.index].key_vault_certificate_subject
  key_vault_certificate_validity_in_months = var.key_vault_app_certificates[count.index].key_vault_certificate_validity_in_months
  key_vault_certificate_action_type        = var.key_vault_app_certificates[count.index].key_vault_certificate_action_type
}

module "kv_app_certificates" {
  count                  = length(var.key_vault_app_certificates)
  source                 = "./modules/azuread-app-certificate-module"
  application_id         = var.key_vault_app_certificates[count.index].application_id
  certificate_end_date   = module.kv_certificates[count.index].certificate_end_date
  certificate_start_date = module.kv_certificates[count.index].certificate_start_date
  certificate_value      = module.kv_certificates[count.index].certificate_value
}