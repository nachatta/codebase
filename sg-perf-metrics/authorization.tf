resource "azurerm_role_assignment" "network_contributor" {
  count                = length(var.keyvault_allowed_principals)
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = element(var.keyvault_allowed_principals, count.index)
}