

variable "shared_acr_pull" {
  type = list(string)
}

variable "location" {
  type = string
  default = "canadaeast"
}

variable "app_config_sub_location" {
  type = string
  default = "canadacentral"
}

variable "resource_prefixes" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "contributor_groups" {
  type = list(string)
}

variable "bot1_app_password" {
  type = string
}

variable "bot2_app_password" {
  type = string
}

variable "sg_shared_cluster_principal_id" {
  default = "adcee2e2-f51a-49b9-bca2-54228bb0256c"
}