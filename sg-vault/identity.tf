
resource "vault_identity_group" "apricot_team" {
  name     = "apricot_team"
  type     = "external"
  policies = ["default", "apricot"]
}

resource "vault_identity_group" "support_team" {
  name     = "support_team"
  type     = "external"
  policies = ["default", "support"]
}

resource "vault_identity_group_alias" "apricot_dev_group_alias" {
  name           = var.apricot_dev_group_id
  mount_accessor = vault_jwt_auth_backend.azure_oidc.accessor
  canonical_id   = vault_identity_group.apricot_team.id
}

resource "vault_identity_group_alias" "support_group_alias" {
  name           = var.support_group_id
  mount_accessor = vault_jwt_auth_backend.azure_oidc.accessor
  canonical_id   = vault_identity_group.support_team.id
}