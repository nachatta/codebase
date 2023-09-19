variable "application_id" {
  type = string
}

variable "certificate_display_name" {
  type    = string
  default = null
}

variable "certificate_value" {
  type      = string
  sensitive = true
}

variable "certificate_start_date" {
  type      = string
}

variable "certificate_end_date" {
  type      = string
}