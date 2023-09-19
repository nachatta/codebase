terraform {
  backend "remote" {
    organization = "ShareGate"
    workspaces {
      name = "sg-gravt-sentinel-audit-prod"
    }
  }
}
