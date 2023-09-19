# Apricot Azure AD Application Secret/Certificate Rotation

## What

Azure AD Application secrets are used by different services to authenticate as the application to different resources.  

**These secrets need to be periodically renewed (rotated) and synced to whichever resource which uses them.**

## Why

For security reasons, these secrets have a finite lifetime. The shorter the better, in case any of them would be compromised.  However, this comes at the cost of operational overhead since we need to make sure all dependant resources use a valid secret.

## How

### Mechanism
In order to sync the source and destination, we trick Terraform into creating a new source object by deleting it from the state.  It's then synced to the destination as a new version.

| Source                                                |             Destination              |
|-------------------------------------------------------|:------------------------------------:|
| Azure AD App Secret                                   | Azure Key Vault Secret (new version) |
| Azure Key Vault Self-Signed Certificate (new version) |       Azure AD App Certificate       |

**For certificates, it's impossible to create a new version in Key Vault with Terraform.  They are managed by Key Vault either with auto-renewal or manually.**


### Initial setup

1. Make sure you login with `az login`
2. `terraform init`
3. `terraform workspace select [workspace_name]`
4. Import your resource to which you're syncing (if it's an existing resource). For example:

   ```terraform
   terraform import \
     "module.kv_secret[1].azurerm_key_vault_secret.key_vault_secret" \
     https://sg-gravt-dev-shared.vault.azure.net/secrets/TeamsBotModule--Bot--BotConfigs--Bot2--AppPassword/212cbb0e8fcc4239a811b44813f916a0

   terraform import \
   "module.kv_certificates[0].azurerm_key_vault_certificate.key_vault_certificate" \
   https://sg-gravt-stg-kv-config.vault.azure.net/certificates/admin-app-client-assertion-certificate/91f71c25e20c414e8bf5793ecc2ab0c7
   ```

### Periodical rotation

1. Make sure you login with `az login`
2. Select the desired workspace/env (qa, shared, staging, production): 

3. `terraform workspace select [workspace_name]`
4. In order to ensure we always create a new secret/certificate, we remove it's state from Terraform (`terraform state rm`) before applying. Do it for all the secrets/certificates with the following scripts:

   `./rm_secret_state.sh`

5. Make sure you're using to right subscription for the resources. Ex:

   **for shared and staging**

   `az account set --subscription sharegate-gravt-dev`

   **for production**

   `az account set --subscription sharegate-gravt-prod` 

6. Apply the terraform state and validate that new secrets are created in the Azure AD Apps and are synced to their respective Key Vault:
   `terraform apply -var-file "vars.$(terraform workspace show).tfvars"`

## Troubleshooting
Sometimes, it can get confusing to know the ID of the synced resource in the state.  You can always pull the state from Terraform Cloud to inspect it's contents:

`terraform state pull > state.json`

**IMPORTANT: NEVER COMMIT THE STATE FILE INTO GIT!**