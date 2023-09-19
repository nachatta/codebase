terraform {
  backend "remote" {
    organization = "ShareGate"
    workspaces {
      name = "sg-shared"
    }
  }
}
