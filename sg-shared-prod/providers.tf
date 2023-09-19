terraform {
  required_version = ">= 1.4.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.58.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias                      = "leapsec-prod"
  subscription_id            = "610a3ca6-183c-49d2-96fa-fb13187eba99"
  skip_provider_registration = "true"
  features {}
}
