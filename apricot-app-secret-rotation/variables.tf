variable "key_vault_app_secrets" {
  description = "Azure AD application secrets which are synced to a key vault secret."
  default = []
}
variable "key_vault_app_certificates" {
  description = "Azure AD application certificate which are synced to a key vault certificate."
  default = []
}