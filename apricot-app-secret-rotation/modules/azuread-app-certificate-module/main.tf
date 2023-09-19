data "azuread_application" "app" {
  application_id = var.application_id
}
resource "azuread_application_certificate" "certificate" {
  application_object_id = data.azuread_application.app.object_id
  type                  = "AsymmetricX509Cert"
  encoding              = "hex"
  value                 = var.certificate_value
  start_date            = var.certificate_start_date
  end_date              = var.certificate_end_date
}