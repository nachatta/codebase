resource "vault_database_secrets_mount" "mongo" {
  for_each = {
    stg  = "staging"
    prod = "prod"
  }
  path = "apricot/${each.key}/mongo"
  mongodbatlas {
    name          = each.value
    allowed_roles = ["reader", "writer", "admin"]
    public_key    = var.mongo_atlas_public_key
    private_key   = var.mongo_atlas_private_key
    project_id    = var.mongo_atlas_project_id
  }
}

resource "vault_database_secret_backend_role" "reader" {
  for_each            = vault_database_secrets_mount.mongo
  name                = "reader"
  backend             = each.value.path
  db_name             = each.value.mongodbatlas[0].name
  default_ttl         = 4 * 3600
  max_ttl             = 24 * 3600
  creation_statements = [
    jsonencode({
      "database_name" : "admin",
      "roles" : [{ "databaseName" : "admin", "roleName" : "readAnyDatabase" }],
      "scopes" : [{ "name" : each.value.mongodbatlas[0].name, "type" : "CLUSTER" }]
    })
  ]
}

resource "vault_database_secret_backend_role" "writer" {
  for_each            = vault_database_secrets_mount.mongo
  name                = "writer"
  backend             = each.value.path
  db_name             = each.value.mongodbatlas[0].name
  default_ttl         = 1 * 3600
  max_ttl             = 4 * 3600
  creation_statements = [
    jsonencode({
      "database_name" : "admin",
      "roles" : [{ "databaseName" : "admin", "roleName" : "readWriteAnyDatabase" }],
      "scopes" : [{ "name" : each.value.mongodbatlas[0].name, "type" : "CLUSTER" }]
    })
  ]
}

resource "vault_database_secret_backend_role" "admin" {
  for_each            = vault_database_secrets_mount.mongo
  name                = "admin"
  backend             = each.value.path
  db_name             = each.value.mongodbatlas[0].name
  default_ttl         = 1 * 3600
  max_ttl             = 4 * 3600
  creation_statements = [
    jsonencode({
      "database_name" : "admin",
      "roles" : [{ "databaseName" : "admin", "roleName" : "atlasAdmin" }],
      "scopes" : [{ "name" : each.value.mongodbatlas[0].name, "type" : "CLUSTER" }]
    })
  ]
}