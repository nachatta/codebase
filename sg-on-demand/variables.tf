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

variable "aks_version" {
  type = string
}

variable "aks_dns_prefix" {
  type = string
}

variable "aks_default_node_pool_count" {
  type = number
}

variable "aks_aad_admin_group_object_ids" {
  type = list(string)
}

variable "default_vm_admin_public_key" {
  type = string
}

variable "eventstore_node_count" {
  type = number
}

variable "eventstore_node_size" {
  type = string
}

variable "eventstore_node_osdisk" {
  type = string
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

variable "terraform_ips" {
  type = list(string)
}

variable "client_assertion_certificate_name" {
  type = string
}

variable "client_assertion_certificate_password" {
  type = string
}

variable "client_assertion_certificate_base64" {
  type = string
}

variable "client_assertion_certificate_password_name" {
  type = string
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

variable "eventstoreca_certificate_name" {
  type = string
}

variable "eventstoreca_certificate_base64" {
  type = string
}

variable "eventstore_appuser_password" {
  type = string
}

variable "eventstore_opsuser_password" {
  type = string
}

variable "security_data_encryption_key" {
  type = string
}

variable "azuread_application_sp_object_id" {
  type = string
}

variable "private_dns_zone_name" {
  type = string
}

variable "search_service_location" {
  type    = string
  default = "canadacentral"
}

variable "search_service_sku" {
  type = string
}

variable "archive_acr_sku" {
  type = string
}

variable "chargebee_api_key" {
  type = string
}

variable "license_manager_api_key" {
  type = string
}

variable "teams_bot_app_password" {
  type = string
}

variable "shared_container_registry_name" {
  type = string
}

variable "shared_container_registry_resource_group_name" {
  type = string
}

variable "datadog_api_key" {
  type = string
}

variable "sharegate_dev_external_dns_clientId" {
  type    = string
  default = "5bb04c08-7b9d-4480-91ff-a8b0149483e1"
}

variable "sharegate_dev_external_dns_secret" {
  type = string
}

variable "cluster_outbound_ip_count" {
  type    = number
  default = 2
}

variable "shared_aks_agentpool_object_id" {
  default = "adcee2e2-f51a-49b9-bca2-54228bb0256c"
}