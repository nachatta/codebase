variable "key_vault_name" {
  type = string
}

variable "key_vault_resource_group_name" {
  type = string
}

variable "key_vault_certificate_name" {
  type = string
}

variable "key_vault_certificate_issuer" {
  default = "Self"
}

variable "key_vault_certificate_subject" {
  type = string
  description = "CN=..."
}

variable "key_vault_certificate_validity_in_months" {
  default = 12
}

variable "key_vault_certificate_key_usages" {
  default = [
    "cRLSign",
    "dataEncipherment",
    "digitalSignature",
    "keyAgreement",
    "keyCertSign",
    "keyEncipherment",
  ]
}

variable "key_vault_certificate_action_type" {
  default = "EmailContacts"
}

variable "key_vault_certificate_trigger_lifetime_percentage" {
  default = 80
}

variable "key_vault_certificate_trigger_days_before_expiry" {
  default = 0
}

variable "key_vault_certificate_content_type" {
  default = "application/x-pkcs12"
}

