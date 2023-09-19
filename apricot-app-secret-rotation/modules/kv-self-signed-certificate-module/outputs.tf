output "certificate_value" {
  value = azurerm_key_vault_certificate.key_vault_certificate.certificate_data
}

output "certificate_start_date" {
  value = azurerm_key_vault_certificate.key_vault_certificate.certificate_attribute[0].not_before
}

output "certificate_end_date" {
  value = azurerm_key_vault_certificate.key_vault_certificate.certificate_attribute[0].expires
}