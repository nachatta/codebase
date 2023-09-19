data "azuread_application" "app" {
  application_id = var.application_id
}

resource "azuread_application_password" "secret" {
  application_object_id = data.azuread_application.app.object_id
  end_date_relative     = var.secret_end_date_relative
  display_name          = var.secret_display_name
}