terraform {
  backend "remote" {
    organization = "ShareGate"
    workspaces {
      name = "sg-vault"
    }
  }

  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "3.12.0"
    }
  }
}
