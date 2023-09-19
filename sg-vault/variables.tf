variable "vault_token" {
  type      = string
  sensitive = true
}

variable "vault_address" {
  type = string
}

variable "oidc_tenant_id" {
  type = string
}

variable "oidc_client_id" {
  type = string
}

variable "oidc_client_secret" {
  type      = string
  sensitive = true
}

variable "oidc_scopes" {
  type = list(string)
}

variable "oidc_allowed_redirect_uris" {
  type = list(string)
}

variable "apricot_dev_group_id" {
  type = string
}

variable "support_group_id" {
  type = string
}

variable "mongo_atlas_public_key" {
  type = string
}

variable "mongo_atlas_private_key" {
  type      = string
  sensitive = true
}

variable "mongo_atlas_project_id" {
  type = string
}