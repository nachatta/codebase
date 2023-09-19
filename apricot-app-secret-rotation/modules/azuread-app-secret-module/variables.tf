variable "application_id" {
  type = string
}

variable "secret_end_date_relative" {
  type    = string
  default = "4380h" # 6 months
}

variable "secret_display_name" {
  type    = string
  default = null
}