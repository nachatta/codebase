terraform {
  required_version = ">=0.14.7"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=2.93.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = ">=2.16.0"
    }
  }
}

provider "azuread" {}

provider "azurerm" {
  features {}
}