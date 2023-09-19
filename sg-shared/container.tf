module "aks_name" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "aks"
  prefixes = var.resource_prefixes
}

module "aks_node_pool_name" {
  source   = "gsoft-inc/naming/azurerm//modules/general/resource_group"
  name     = "nodes"
  prefixes = concat(var.resource_group_prefixes, ["aks"])
}

module "acr_name" {
  source   = "gsoft-inc/naming/azurerm//modules/containers/container_registry"
  name     = "acr"
  prefixes = var.resource_prefixes
}

resource "azurerm_kubernetes_cluster" "shared" {
  name                              = module.aks_name.result
  location                          = azurerm_resource_group.shared.location
  resource_group_name               = azurerm_resource_group.shared.name
  azure_policy_enabled              = false
  http_application_routing_enabled  = false
  oidc_issuer_enabled               = false
  open_service_mesh_enabled         = false
  public_network_access_enabled     = true
  role_based_access_control_enabled = true
  run_command_enabled               = true
  node_resource_group               = module.aks_node_pool_name.result
  dns_prefix                        = var.aks_dns_prefix
  kubernetes_version                = var.aks_version

  default_node_pool {
    name                 = "d2sv3"
    node_count           = var.aks_default_node_pool_count
    vm_size              = var.aks_default_node_pool_size
    vnet_subnet_id       = azurerm_subnet.shared.id
    tags                 = var.tags
  }

  identity {
    type = "SystemAssigned"
  }
 
  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = var.aks_aad_admin_group_object_ids
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = false
    secret_rotation_interval = "2m"
  }
  
  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = local.aks.dns_service_ip
    service_cidr       = local.aks.service_cidr
    docker_bridge_cidr = local.aks.docker_bridge_cidr

    load_balancer_profile {
      outbound_ip_address_ids = [azurerm_public_ip.aks_outbound.id]
    }
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "d8sv5" {
  name                  = "d8sv5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.shared.id
  vm_size               = "Standard_D8ds_v5"
  node_count            = 1
  vnet_subnet_id        = azurerm_subnet.shared.id
  tags                  = var.tags
  enable_auto_scaling   = true
  max_count             = 5
  min_count             = 1
  node_taints           = ["role=azdevops_agent:PreferNoSchedule"]

  # nodes auto-scale and count is dynamic
  lifecycle {
    ignore_changes = [node_count]
  }
}

resource "azurerm_container_registry" "acr" {
  name                = module.acr_name.result
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  sku                 = "Standard"
  admin_enabled       = true
  tags = var.tags
}