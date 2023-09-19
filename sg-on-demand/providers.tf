terraform {
  required_version = ">=0.14.7"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.92.0"
      
    }
    random = {
      source = "hashicorp/random"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = ">=0.6.5"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azurerm" {
  features {}
  alias = "sharegate_shared_dev"
  subscription_id = "2a71ff47-745b-4a86-a128-e8e969d03802"
}

provider "mongodbatlas" {
  public_key    = var.mongodbatlas_public_key
  private_key   = var.mongodbatlas_private_key
}