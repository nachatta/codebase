terraform {
  backend "remote" {
    organization = "ShareGate"
    workspaces {
      prefix = "sg-gravt-"
    }
  }
}
