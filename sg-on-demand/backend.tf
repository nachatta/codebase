terraform {
  backend "remote" {
    organization = "ShareGate"
    workspaces {
      name = "sg-on-demand"
    }
  }
}
