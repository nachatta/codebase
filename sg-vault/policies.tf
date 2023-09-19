resource "vault_policy" "apricot" {
  name = "apricot"

  policy = <<EOT
path "apricot/stg/mongo/*" {
  capabilities = ["read", "create", "update"]
}
path "apricot/prod/mongo/*" {
  capabilities = ["read", "create", "update"]
}
EOT
}

resource "vault_policy" "support" {
  name = "support"

  policy = <<EOT
path "apricot/stg/mongo/creds/reader" {
  capabilities = ["read", "create", "update"]
}
path "apricot/prod/mongo/creds/reader" {
  capabilities = ["read", "create", "update"]
}
EOT
}