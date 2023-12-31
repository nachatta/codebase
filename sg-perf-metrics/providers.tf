terraform {
  required_version = ">=0.15.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.20.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "azurerm" {
  features {}
}
