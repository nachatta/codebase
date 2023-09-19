resource "vault_jwt_auth_backend" "azure_oidc" {
  oidc_discovery_url = "https://login.microsoftonline.com/${var.oidc_tenant_id}/v2.0"
  path               = "oidc"
  type               = "oidc"
  oidc_client_id     = var.oidc_client_id
  oidc_client_secret = var.oidc_client_secret
  default_role       = "default_role"
  provider_config    = {
    provider = "azure"
  }
}

resource "vault_jwt_auth_backend_role" "azure_role" {
  role_name             = "default_role"
  backend               = vault_jwt_auth_backend.azure_oidc.path
  user_claim            = "email"
  groups_claim          = "groups"
  role_type             = "oidc"
  oidc_scopes           = var.oidc_scopes
  allowed_redirect_uris = var.oidc_allowed_redirect_uris
  token_policies        = [
    "default",
  ]
}