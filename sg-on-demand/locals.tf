locals {
  aks = {
    dns_service_ip      = "10.240.0.2"
    service_cidr        = "10.240.0.0/16"
    docker_bridge_cidr  = "172.17.0.1/16"
  }
}