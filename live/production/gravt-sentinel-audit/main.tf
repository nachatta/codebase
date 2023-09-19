terraform {
  required_version = "1.5.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.58.0"
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

data "terraform_remote_state" "sg_gravt_prod" {
  backend = "remote"

  config = {
    organization = "ShareGate"
    workspaces = {
      name = "sg-gravt-prod"
    }
  }
}

data "azurerm_log_analytics_workspace" "sentinel" {
  provider            = azurerm.leapsec-prod
  name                = "gsec-prod-log-sentinel"
  resource_group_name = "gsec-sentinel-prod"
}
