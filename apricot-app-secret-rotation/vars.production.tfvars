key_vault_app_secrets = [
  {
    "application_name" : "[Teams App] ShareGate",
    "application_id" : "5ae4d705-5913-44a7-9769-24d2013a4d31",
    "key_vault_name" : "sg-gravt-prod-kv-config",
    "key_vault_resource_group_name" : "gravt-prod",
    "key_vault_secret_name" : "TeamsBotModule--Bot--BotConfigs--Bot1--AppPassword"
  }
]
key_vault_app_certificates = [
  {
    "application_name" : "ShareGate Apricot Operations",
    "application_id" : "b9ea140f-698e-406c-ace8-9e58bfd47e52",
    "key_vault_name" : "sg-gravt-prod-kv-config",
    "key_vault_resource_group_name" : "gravt-prod",
    "key_vault_certificate_name" : "admin-app-client-assertion-certificate"
    "key_vault_certificate_subject" : "E=infra@gsoft.com, CN=prod.apricot.admin-client-assertion.sharegate.com, OU=Apricot, O=ShareGate, L=Montreal, S=QC, C=CA",
    "key_vault_certificate_validity_in_months": 13,
    "key_vault_certificate_action_type": "EmailContacts"
  },
  {
    "application_name" : "ShareGate Teams management",
    "application_id" : "fc6e8c0d-0316-409c-a5ef-cd4c9ae41331",
    "key_vault_name" : "sg-gravt-prod-kv-config",
    "key_vault_resource_group_name" : "gravt-prod",
    "key_vault_certificate_name" : "client-assertion-certificate",
    "key_vault_certificate_subject" : "E=infra@gsoft.com, CN=prod.apricot.client-assertion.sharegate.com, OU=Apricot, O=ShareGate, L=Montreal, S=QC, C=CA",
    "key_vault_certificate_validity_in_months": 13,
    "key_vault_certificate_action_type": "EmailContacts"
  }
]