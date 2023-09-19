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
    "52.139.90.40" #zscaler
    ] 
}

variable "keyvault_allowed_principals" {
  type = list(string)
}

variable "azdevops_access_token" {
  type = string
}

variable "bi_db_connection_string" {
  type = string
}

variable "bi_db_admin_password" {
  type = string
}

variable "desktop_azure_release_container_url" {
  type = string
}

variable "desktop_mixpanel_api_secret" {
  type = string
}

variable "jira_username" {
  type = string
}

variable "jira_password" {
  type = string
}