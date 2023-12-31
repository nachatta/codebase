terraform {
  required_version = ">=0.14.7"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=2.92.0"
    }
  }
}

provider "azurerm" {
  features {}
}