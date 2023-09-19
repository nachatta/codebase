data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
}

resource "azurerm_key_vault_certificate" "key_vault_certificate" {
  name         = var.key_vault_certificate_name
  key_vault_id = data.azurerm_key_vault.key_vault.id

  certificate_policy {
    issuer_parameters {
      name = var.key_vault_certificate_issuer
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = var.key_vault_certificate_action_type
      }

      trigger {
        days_before_expiry  = var.key_vault_certificate_trigger_days_before_expiry
        lifetime_percentage = var.key_vault_certificate_trigger_lifetime_percentage
      }
    }

    secret_properties {
      content_type = var.key_vault_certificate_content_type
    }

    x509_certificate_properties {
      key_usage          = var.key_vault_certificate_key_usages
      subject            = var.key_vault_certificate_subject
      validity_in_months = var.key_vault_certificate_validity_in_months
    }
  }
}