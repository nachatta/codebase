data "azurerm_resource_group" "apricot_shared" {
  name = "apricot-shared"
}

data "azurerm_client_config" "current" {}