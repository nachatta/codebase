module "cluster_aks_name" {
  source  = "gsoft-inc/naming/azurerm"
  version = "0.5.0"

  name     = "cluster"
  prefixes = var.resource_prefixes
}

module "main_cluster_node_pool_name" {
  source  = "gsoft-inc/naming/azurerm//modules/general/resource_group"
  version = "0.5.0"

  name = "nodes"
  prefixes = concat(var.resource_group_prefixes, [
    "cluster"
  ])
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                 = module.cluster_aks_name.result
  location             = azurerm_resource_group.aks.location
  resource_group_name  = azurerm_resource_group.aks.name
  node_resource_group  = module.main_cluster_node_pool_name.result
  dns_prefix           = var.cluster_dns_prefix
  kubernetes_version   = var.aks_version
  sku_tier             = "Standard"
  azure_policy_enabled = var.cluster_azure_policy_enabled

  default_node_pool {
    name                 = var.cluster_default_pool_name
    vm_size              = var.cluster_default_pool_vm_size
    vnet_subnet_id       = azurerm_subnet.cluster.id
    tags                 = var.tags
    enable_auto_scaling  = true
    min_count            = var.cluster_default_pool_min_node
    node_count           = var.cluster_default_pool_min_node
    max_count            = var.cluster_default_pool_max_node
    orchestrator_version = var.aks_version
  }

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = local.cluster.service_cidr
    dns_service_ip = local.cluster.dns_service_ip

    load_balancer_profile {
      outbound_ip_prefix_ids = [azurerm_public_ip_prefix.cluster_outbound_prefix.id]
    }
  }

  api_server_access_profile {
    authorized_ip_ranges = concat(var.gsoft_ips, var.deployment_pipeline_ips)
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.analytics_workspace.id
  }
}
