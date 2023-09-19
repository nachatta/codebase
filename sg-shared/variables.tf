variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "resource_prefixes" {
  type = list(string)
}

variable "resource_group_prefixes" {
  type = list(string)
}

variable "gsoft_ips" {
  type = list(string)
  default = [
    "52.139.90.40", #zscaler
    "20.151.26.183/32", #aks cluster build agent
  ] 
}

variable "aks_version" {
  type = string
}

variable "aks_dns_prefix" {
  type = string
}

variable "aks_default_node_pool_count" {
  type = number
}

variable "aks_default_node_pool_size" {
  type = string
}

variable "aks_aad_admin_group_object_ids" {
  type = list(string)
}

variable "ssl_certificate_name" {
  type = string
}

variable "ssl_certificate_password" {
  type = string
}

variable "ssl_certificate_base64" {
  type = string
}

variable "ssl_certificate_password_name" {
  type = string
}

variable "keyvault_allowed_users_dev" {
  type = list(string)
}

variable "keyvault_allowed_users_sre" {
  type = list(string)
}

variable "datadog_api_key_name" {
  type = string
}

variable "datadog_api_key_value" {
  type = string
}

variable "ansible_awx_app_object_id" {
  type = string
}

variable "qa_aks_agentpool_client_id" {
  type = string
  default = "08137af9-c66c-4ac0-a3bc-41e8424d72f5"
}

variable "staging_aks_agentpool_client_id" {
  type = string
  default = "b0c74cf7-cd20-4b66-9a44-b60862b6f905"
}

variable "dev_build_agent_object_id" {
  type = string
  default = "e7b37be9-4ef7-4236-a44b-f60cbdbcd2ad"
}

variable "shared_aks_agentpool_client_id" {
  type = string
  default = "adcee2e2-f51a-49b9-bca2-54228bb0256c"
}

variable "shared_app_aks_id" {
  default = "/subscriptions/2a71ff47-745b-4a86-a128-e8e969d03802/resourceGroups/sharegate-shared-main-lqqfdcyt8qsfv/providers/Microsoft.Network/publicIPAddresses/sg-shared-aks-inbound-uhmwdfi0vhyho"
}

variable "staging_app_aks_id_public" {
  default = "/subscriptions/6edfbbb4-cc4e-4bba-9a8f-361b1696bf0e/resourceGroups/gravt-staging-aks-1ufvfn3yn6zgd/providers/Microsoft.Network/publicIPAddresses/sg-gravt-stg-cluster-inbound-tx76ap2ljwz3e"
}

variable "staging_app_aks_id_private" {
  default = "/subscriptions/6edfbbb4-cc4e-4bba-9a8f-361b1696bf0e/resourceGroups/gravt-staging-aks-1ufvfn3yn6zgd/providers/Microsoft.Network/publicIPAddresses/sg-gravt-stg-cluster-inbound-4n8ouloa6alvu"
}

variable "staging_app_aks_id_embedded" {
  default = "/subscriptions/6edfbbb4-cc4e-4bba-9a8f-361b1696bf0e/resourceGroups/gravt-staging-aks-1ufvfn3yn6zgd/providers/Microsoft.Network/publicIPAddresses/sg-gravt-stg-cluster-embedded-ml4pdbj1hncb3"
}

variable "apricot_qa_aks_pool_object_id" {
  type = string
  default = "08137af9-c66c-4ac0-a3bc-41e8424d72f5"
}

variable "staging_api_dns_record_names" {
  type = list(string)
  default = ["apricot-stg-api", "app-stg-api"]
}

variable "staging_admin_api_dns_record_names" {
  type = list(string)
  default = ["apricot-stg-admin-api", "app-stg-admin-api"]
}

variable "staging_webapp_dns_record_names" {
  type = list(string)
  default =  ["apricot-stg", "app-stg"]
}

variable "staging_admin_webapp_dns_record_names" {
  type = list(string)
  default = ["apricot-stg-admin", "app-stg-admin"]
}

variable "staging_statusapp_dns_record_names" {
  type = list(string)
  default = ["apricot-stg-status", "apricot-stg-status"]
}

variable "staging_demoapp_dns_record_names" {
  type = list(string)
  default = ["apricot-stg-demo", "app-stg-demo"]
}

variable "staging_teams_dns_record_names" {
  type = list(string)
  default = ["apricot-stg-teams", "app-stg-teams"]
}

variable "staging_help_dns_record_names" {
  type = list(string)
  default = ["apricot-stg-help", "app-stg-help"]
}

variable "staging_es_dns_record_names" {
  type = list(string)
  default = ["apricot-stg-es", "app-stg-es"]
}

variable "acr_reader_group_object_ids" {
  type = list(string)
}

variable "log_analytics_workspace_id" {
  type = string
}