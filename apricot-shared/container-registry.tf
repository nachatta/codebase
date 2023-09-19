data "azurerm_container_registry" "shared" {
  name = "sg0apricot0shared0acr"
  resource_group_name = data.azurerm_resource_group.apricot_shared.name
}

resource "azurerm_role_assignment" "acrpull" {
  scope = data.azurerm_container_registry.shared.id
  role_definition_name = "AcrPull"
  for_each = toset(var.shared_acr_pull)
  principal_id = each.key
}
