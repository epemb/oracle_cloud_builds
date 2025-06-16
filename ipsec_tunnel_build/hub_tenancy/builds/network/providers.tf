terraform {

  required_providers {
    hcp = {
      source = "hashicorp/hcp"
      version = "0.91.0"
    }
    oci = {
      source = "oracle/oci"
      version = "6.31.0"
    }
  }
}

data "hcp_vault_secrets_app" "provider_secrets"{
    app_name = "oracle-tenancy-secrets"
}

provider "oci" {
    tenancy_ocid      = data.hcp_vault_secrets_app.provider_secrets.secrets["tenancy_ocid"]
    user_ocid         = data.hcp_vault_secrets_app.provider_secrets.secrets["user_ocid"]
    fingerprint       = data.hcp_vault_secrets_app.provider_secrets.secrets["fingerprint"]
    private_key_path  = data.hcp_vault_secrets_app.provider_secrets.secrets["private_key_path"]
    region            = "us-ashburn-1"

}