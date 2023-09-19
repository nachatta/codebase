locals {
  aks = {
    dns_service_ip     = "10.0.3.2"
    service_cidr       = "10.0.3.0/24"
    docker_bridge_cidr = "172.17.0.1/16"
  }
}
