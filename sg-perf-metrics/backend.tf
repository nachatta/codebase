terraform {
  backend "remote" {
    organization = "ShareGate"
    workspaces {
      name = "sg-perf-metrics"
    }
  }
}
