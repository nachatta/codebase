variable "key_vault_name" {
  type = string
}

variable "key_vault_resource_group_name" {
  type = string
}

variable "key_vault_secret_name" {
  type = string
}

variable "key_vault_secret_value" {
  type = string
  sensitive = true
}

