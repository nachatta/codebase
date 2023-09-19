resource "azurerm_container_registry" "gravt_acr" {
  count = var.acr.enabled ? 1 : 0

  name                = var.acr.name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  sku                 = var.acr.sku
  tags                = var.tags
}
