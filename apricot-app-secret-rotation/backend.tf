terraform {
  backend "remote" {
    organization = "ShareGate"
    workspaces {
      prefix = "apricot-app-secret-rotation-"
    }
  }
}
