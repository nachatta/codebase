variable "location" {
  type = string
}

variable "resource_prefixes" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "cert_readers_object_ids" {
  type = list(string)
}
