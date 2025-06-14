# Data source used to pull in the main_compartment_id secret from HCP Vault Secrets
data "hcp_vault_secrets_app" "main_compartment_id" {
    app_name = "oracle-tenancy-secrets"
}

data "oci_core_subnets" "pub_subnet" {
    compartment_id = data.hcp_vault_secrets_app.main_compartment_id.secrets["main_compartment_id"]
    display_name = "pub_subnet"
}

module "bastion" {
    source = "../../modules/bastion"

    bastion_info = [{
        name = "bastion"
        compartment_id = data.hcp_vault_secrets_app.main_compartment_id.secrets["main_compartment_id"]
        target_subnet_id = data.oci_core_subnets.pub_subnet.subnets[0].id
        client_cidr_block_allow_list = [data.hcp_vault_secrets_app.main_compartment_id.secrets["my_pub_ip"]]
    }]
}