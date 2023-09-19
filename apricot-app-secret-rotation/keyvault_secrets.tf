module "kv_app_secret" {
  count                    = length(var.key_vault_app_secrets)
  source                   = "./modules/azuread-app-secret-module"
  application_id           = var.key_vault_app_secrets[count.index].application_id
  secret_end_date_relative = "4380h" # 6 months

  # Add some context to app secret display name / description
  secret_display_name      = <<EOT
  ${var.key_vault_app_secrets[count.index].key_vault_resource_group_name} | ${var.key_vault_app_secrets[count.index].key_vault_name} | ${var.key_vault_app_secrets[count.index].key_vault_secret_name}
  EOT
}

module "kv_secret" {
  count                         = length(var.key_vault_app_secrets)
  source                        = "./modules/kv-secret-module"
  key_vault_name                = var.key_vault_app_secrets[count.index].key_vault_name
  key_vault_resource_group_name = var.key_vault_app_secrets[count.index].key_vault_resource_group_name
  key_vault_secret_name         = var.key_vault_app_secrets[count.index].key_vault_secret_name
  key_vault_secret_value        = module.kv_app_secret[count.index].secret
}