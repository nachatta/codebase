module "servicebus_name" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "servicebus"
  prefixes = var.resource_prefixes
}

resource "azurerm_servicebus_namespace" "main" {
  name = module.servicebus_name.result
  location = var.location
  resource_group_name = data.azurerm_resource_group.apricot_shared.name
  sku = "Standard"
  
  tags = var.tags
}

resource "azurerm_key_vault_secret" "service_bus" {
  key_vault_id = azurerm_key_vault_access_policy.terraform_workspace_identity.key_vault_id
  name = "Azure--ServiceBus--ConnectionString"
  value = azurerm_servicebus_namespace.main.default_primary_connection_string
}

resource "azurerm_role_assignment" "service_bus_contributors" {
  for_each = toset(var.contributor_groups)
  principal_id = each.key
  scope = azurerm_servicebus_namespace.main.id
  role_definition_name = "Contributor"
}