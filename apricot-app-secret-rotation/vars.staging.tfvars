key_vault_app_secrets = [
  {
    "application_name" : "[Teams App] ShareGate (Staging)",
    "application_id" : "a33e84ff-47ae-4ad0-b4a6-bb676f9d583c",
    "key_vault_name" : "sg-gravt-stg-kv-config",
    "key_vault_resource_group_name" : "gravt-staging",
    "key_vault_secret_name" : "TeamsBotModule--Bot--BotConfigs--Bot1--AppPassword"
  }
]
key_vault_app_certificates = [
  {
    "application_name" : "ShareGate Apricot Operations",
    "application_id" : "b9ea140f-698e-406c-ace8-9e58bfd47e52",
    "key_vault_name" : "sg-gravt-stg-kv-config",
    "key_vault_resource_group_name" : "gravt-staging",
    "key_vault_certificate_name" : "admin-app-client-assertion-certificate",
    "key_vault_certificate_subject" : "E=infra@gsoft.com, CN=stg.apricot.admin-client-assertion.sharegate.com, OU=Apricot, O=ShareGate, L=Montreal, S=QC, C=CA",
    "key_vault_certificate_validity_in_months": 13
    "key_vault_certificate_action_type": "AutoRenew"
  },
  {
    "application_name" : "ShareGate Teams management (Staging)",
    "application_id" : "9ecbd0c3-1dac-463d-91cc-ad59c0585e3e",
    "key_vault_name" : "sg-gravt-stg-kv-config",
    "key_vault_resource_group_name" : "gravt-staging",
    "key_vault_certificate_name" : "client-assertion-certificate",
    "key_vault_certificate_subject" : "E=infra@gsoft.com, CN=stg.apricot.client-assertion.sharegate.com, OU=Apricot, O=ShareGate, L=Montreal, S=QC, C=CA",
    "key_vault_certificate_validity_in_months": 13,
    "key_vault_certificate_action_type": "AutoRenew"
  }
]