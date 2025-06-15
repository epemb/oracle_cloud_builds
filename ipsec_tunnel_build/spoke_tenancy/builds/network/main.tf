data "hcp_vault_secrets_app" "network_secrets" {
    app_name = "oracle-tenancy-secrets"
}


module "igw" {
    source = "../../modules/igw"

    igw_info = [{
        compartment_id = data.hcp_vault_secrets_app.network_secrets.secrets["spoke_main_compartment_id"]
        vcn_id = module.vcn.vcn_id
        display_name = "spoke-igw"
    }]

}

module "vcn" {
    source = "../../modules/vcn"

    vcn_info = [
        {
        compartment_id  = data.hcp_vault_secrets_app.network_secrets.secrets["spoke_main_compartment_id"]
        cidr_block      = var.vcn_cidr_block
        display_name    = "spoke-vcn-ashburn"
    }
    ]
}

module "pub_subnets" {
    source = "../../modules/subnet"
    subnet_info = local.pub_subnets

}

resource "oci_core_route_table" "pub_subnet_rt" {
    compartment_id = data.hcp_vault_secrets_app.network_secrets.secrets["spoke_main_compartment_id"]
    vcn_id = module.vcn.vcn_id
    display_name = "Default Route Table for pub-subnet"

    route_rules {
        network_entity_id = module.igw.id["spoke-igw"]
        description = "Forwards packets in pub subnet to IGW."
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }
}