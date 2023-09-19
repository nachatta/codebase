module "main_aks_name" {
  source   = "gsoft-inc/naming/azurerm"
  name     = "aks"
  prefixes = var.resource_prefixes
}

module "main_aks_node_pool_name" {
  source   = "gsoft-inc/naming/azurerm//modules/general/resource_group"
  name     = "nodes"
  prefixes = concat(var.resource_group_prefixes, ["aks"])
}

module "archive_acr_name" {
  source   = "gsoft-inc/naming/azurerm//modules/containers/container_registry"
  name     = "archive"
  prefixes = var.resource_prefixes
}


resource "azurerm_kubernetes_cluster" "main" {
  name                = module.main_aks_name.result
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  node_resource_group = module.main_aks_node_pool_name.result
  dns_prefix          = var.aks_dns_prefix
  kubernetes_version  = var.aks_version

  default_node_pool {
    name                 = "ds4v5"
    node_count           = var.aks_default_node_pool_count
    vm_size              = "Standard_D4s_v5"
    vnet_subnet_id       = azurerm_subnet.aks.id
    tags                 = var.tags
    enable_auto_scaling  = true
    max_count            = 6
    min_count            = 2
    orchestrator_version = var.aks_version
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true

    azure_active_directory {
      managed                = true
      admin_group_object_ids = var.aks_aad_admin_group_object_ids
    }
  }

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = local.aks.dns_service_ip
    service_cidr       = local.aks.service_cidr
    docker_bridge_cidr = local.aks.docker_bridge_cidr

    load_balancer_profile {
      outbound_ip_prefix_ids = [azurerm_public_ip_prefix.aks_outbound_prefix.id]
    }
  }

  api_server_authorized_ip_ranges = concat(var.gsoft_ips, var.deployment_pipeline_ips)

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count
    ]
  }
}

resource "azurerm_container_registry" "archive" {
  name                = module.archive_acr_name.result
  resource_group_name = azurerm_resource_group.archives.name
  location            = azurerm_resource_group.archives.location
  sku                 = var.archive_acr_sku
  admin_enabled       = true

  tags = var.tags
}


resource "azurerm_role_assignment" "sgd_shared_archive" {
  scope                = azurerm_container_registry.archive.id
  role_definition_name = "AcrPush"
  principal_id         = "89ccf6d9-ef4c-43d0-9a53-ff0711443d4f" # sharegate-desktop-dev build automation
}
