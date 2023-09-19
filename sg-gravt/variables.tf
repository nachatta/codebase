locals {
  private_endpoint_kv          = format("%s-pv-kv", var.resource_name_prefix)
  private_endpoint_kvconfig    = format("%s-pv-kvconfig", var.resource_name_prefix)
  private_endpoint_blobstorage = format("%s-pv-blobstorage", var.resource_name_prefix)
  private_endpoint_sqlserver   = format("%s-pv-sqlserver", var.resource_name_prefix)
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "resource_prefixes" {
  type        = list(string)
  description = "Prefixes used to create multiple resources name with the naming module."
}

variable "resource_group_prefixes" {
  type        = list(string)
  description = "TODO: Prefixes used for the naming of the aks resource group and clsuter main node pool. Can be deleted to use resource_prefixes everywhere?"
}

variable "gsoft_ips" {
  type = list(string)
  default = [
    "52.139.90.40/32", #zscaler
  ]
}

variable "deployment_pipeline_ips" {
  type = list(string)
  default = [
    "20.151.26.183/32", #aks cluster build agent
  ]
}

variable "acr" {
  description = "Configurations for azure container registry, enabled must be set to true"

  type = object({
    enabled = bool
    name    = string
    sku     = string
  })

  default = {
    enabled = false
    name    = "acr"
    sku     = "Standard"
  }
}

variable "analytics_workspace_name" {
  type        = string
  description = "TODO: There are two active Log Analytics Workspace on the sharegate-gravt-dev sub: 'sg-gravt-stg-log-analytics' and 'defaultworkspace-6edfbbb4-cc4e-4bba-9a8f-361b1696bf0e-yq'"
}

variable "analytics_workspace_resource_group" {
  type = string
}

variable "aks_version" {
  type = string
}

variable "cluster_dns_prefix" {
  type = string
}

variable "ask_cloud_copy_workload_identity_object_id" {
  type        = string
  description = "TODO: Validate if requires downtime in cloudcopy during data migration."
}

variable "rg_main_name" {
  type        = string
  description = "Name of the main resource group."
}

variable "shared_private_dns_zone" {
  type = string
}

variable "gravt_cluster_admin_group" {
  type        = string
  description = "AAD Group id which should have Admin Role on AKS."
}

variable "gravt_cluster_user_groups" {
  type        = list(string)
  description = "List of AAD Group id to have the  Azure Kubernetes Service Cluster User Role role"
}

variable "admin_app_client_assertion_certificate_password" {
  type        = string
  description = "TODO: Remove since we don't need a certificate for admin assertion anymore."
}

variable "cluster_outbound_prefix_length" {
  type        = number
  default     = 30
  description = "TODO: Validate, 30 is the same value as the existing staging environment"
}

variable "cluster_default_pool_name" {
  type = string
}

variable "cluster_default_pool_vm_size" {
  type = string
}

variable "cluster_default_pool_min_node" {
  type = number
}

variable "cluster_default_pool_max_node" {
  type = number
}

variable "workspace" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "resource_name_prefix" {
  type        = string
  description = "Base resource name prefix."
}

variable "ARM_TENANT_ID_LEGACY" {
  type        = string
  description = "TODO: Same value as the env ARM_TENANT_ID but not an env variable. Validate access"
}

variable "aad_app_id_legacy" {
  type        = string
  description = "TODO: Remove. We think it's legacy before aks: we now use managed identity of the cluster."
}

variable "aad_deployment_id_legacy" {
  type        = string
  description = "TODO: Remove. We think it's legacy before aks and we don't know why CI/CD pipelines should have access to keyvault."
}

variable "aad_group_contributor_with_lock" {
  type        = string
  description = "AAD Group required to have access to ressources."
}

variable "licensingmodule_chargebee_apikey" {
  type        = string
  sensitive   = true
  description = "TODO: Find out how to renew."
}

variable "analyticsmodule_azure_storage_accountname" {
  type        = string
  description = "TODO: Can be deleted, no reference in the code. Seems to have been removed 2022-01"
}

variable "analyticsmodule_azure_storage_sastoken" {
  type        = string
  description = "TODO: Can be deleted, no reference in the code. Seems to have been removed 2022-01"
  sensitive   = true
}

variable "security_data_encryption_key" {
  type        = string
  description = "Secret used to encrypt globally when not using encryption by tenant."
  sensitive   = true
}

variable "mandrill_api_key" {
  type        = string
  sensitive   = true
  description = "TODO: Check how to renew for real! Is also in clear in staging.json"
}

variable "aad_admin_app_group_id" {
  type        = string
  description = "AAD Group required for admin operation on the Admin app, TODO: should be in appsettings"
}

variable "almmodule_notification_token_secret" {
  type        = string
  sensitive   = true
  description = "Secret to encrypt JWT token for Notification (exclusing Group Security) (i.e: unused group)"
}

variable "teamsbotmodule_actiontokensecret" {
  type        = string
  sensitive   = true
  description = "Action token secret for Teams bot, used to sign the JWT token."
}

variable "teamsbotmodule_bot_apppassword" {
  type        = string
  sensitive   = true
  description = "App secret for Teams bot, TODO: Check how to renew this."
}

variable "almmodule_groups_security_token_secret" {
  type        = string
  sensitive   = true
  description = "Secret to encrypt JWT token for Group Security Notification (external sharing)"
}

variable "licensingmodule_licensemanager_apikey" {
  type        = string
  sensitive   = true
  description = "TODO: Check how to renew for real!"
}

variable "datadog_api_key" {
  type        = string
  sensitive   = true
  description = "TODO: Check how to renew for real!"
}

variable "client_assertion_certificate_name" {
  type = string
}

variable "client_assertion_certificate_pwd" {
  type      = string
  sensitive = true
}

variable "mongodb_connectionstring" {
  type        = string
  sensitive   = true
  description = "TODO: Check how to renew for real"
}

variable "mongodb_akka_connectionstring" {
  type      = string
  sensitive = true
}

variable "mongodb_analytics_connectionstring" {
  type      = string
  sensitive = true
}

variable "eventstore_appuser_password" {
  type        = string
  sensitive   = true
  description = "TODO: Check how to renew for real"
}

variable "eventstore_opsuser_password" {
  type        = string
  sensitive   = true
  description = "TODO: Check how to renew for real"
}

variable "msal_cache_sql_server_admin_username" {
  type        = string
  description = "The login username of the Azure AD Administrator of the SQL Server."
}

variable "msal_cache_sql_server_admin_objectid" {
  type        = string
  description = "The object id of the Azure AD Administrator of the SQL Server."
}

variable "msal_cache_sql_collation" {
  type        = string
  description = "Collation type for Msal sql cache, TODO: Seems to be default value and can be removed"
}

variable "msal_cache_sql_size_gb" {
  type = number
}

variable "msal_cache_sql_sku_name" {
  type = string
}

variable "msal_cache_sql_storage_account_type" {
  type        = string
  description = "Specifies the storage account type used to store backups for this database."
}

variable "create_eventstore_ca_certificate" {
  type = bool
}

variable "eventstore_ca_certificate_name" {
  type = string
}

variable "eventstore_ca_certificate_pwd" {
  type      = string
  sensitive = true
}

variable "use_private_endpoint" {
  type = bool
}

variable "main_vnet_address_space" {
  type = list(string)
}

variable "main_subnet_address_prefixes" {
  type = list(string)
}

variable "cluster_subnet_address_prefixes" {
  type = list(string)
}

variable "cluster_azure_policy_enabled" {
  type = bool
}

variable "provisioning_api_gateway_fusion_auth_client_secret" {
  type        = string
  sensitive   = true
  description = "Fusion auth secret used by the provisioning api gateway"
}

variable "cloud_copy_api_fusion_auth_client_secret" {
  type        = string
  sensitive   = true
  description = "Fusion auth secret used by the cloud copy api"
}

variable "monolith_fusion_auth_client_secret" {
  type        = string
  sensitive   = true
  description = "Fusion auth secret used to identify as the monolith entity"
}

variable "archive_search_service_sku" {
  type = string
}

variable "archive_search_service_partition_count" {
  type        = number
  description = "Number of partition for the search service of archive"
  default     = 1
}

variable "imported_legacy" {
  description = "Configuration to import legacy ressource"

  type = object({
    enabled                      = bool
    appKeyvaultName              = string
    msalKeyvaultName             = string
    storageAccountName           = string
    sqlServerName                = string
    sqlDatabaseName              = string
    archiveSearchServiceName     = string
    archiveSearchServiceLocation = string
    eventStoreResourceGroup      = string
    eventStoreVirtualNetworkName = string
  })

  default = {
    enabled                      = false
    appKeyvaultName              = ""
    msalKeyvaultName             = ""
    storageAccountName           = ""
    sqlServerName                = ""
    sqlDatabaseName              = ""
    archiveSearchServiceName     = ""
    archiveSearchServiceLocation = ""
    eventStoreResourceGroup      = ""
    eventStoreVirtualNetworkName = ""
  }
}

variable "kv_config_secrets_expiration_date" {
  type        = string
  description = "The expiration date that will be applied to every secrets in the kv_config keyvault"
  default     = "2025-09-15T00:00:00Z"
}

variable "kv_config_keys_expiration_date" {
  type        = string
  description = "The expiration date that will be applied to every keys in the kv_config keyvault"
  default     = "2025-09-15T00:00:00Z"
}
