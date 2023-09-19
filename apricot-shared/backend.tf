terraform {
  backend "remote" {
    organization = "ShareGate"
    workspaces {
      name = "apricot-shared"
    }
  }
}
