data "hcp_vault_secrets_app" "network_secrets"{
    app_name = "oracle-tenancy-secrets"
}

resource "oci_core_drg" "hub_drg" {    
    compartment_id = data.hcp_vault_secrets_app.network_secrets.secrets["main_compartment_id"]
    display_name = "hub-drg"
}


module "drg_attachment" {
source = "../../drg_attachment"
    drg_attachment_info = [{
        drg_id = oci_core_drg.hub_drg.id
        display_name = "priv-drg-attachment"
        drg_route_table_id = oci_core_drg_route_table.priv_drg_rt.id
        id = module.vcn.vcn_id
        type = "VCN"
        route_table_id = null
    }]
}

resource "oci_core_drg_route_table" "priv_drg_rt" {
    drg_id = oci_core_drg.test_drg.id
    display_name = "priv-drg-rt"
    import_drg_route_distribution_id = oci_core_drg_route_distribution.priv_rd.id
    is_ecmp_enabled = false
}

resource "oci_core_drg_route_distribution" "priv_rd" {
    distribution_type = "IMPORT"
    drg_id = oci_core_drg.hub_drg.id
    display_name = "priv-import-rd"
}

resource "oci_core_drg_route_distribution_statement" "priv_rd_statements" {
    drg_route_distribution_id = oci_core_drg_route_distribution.priv_import_rd.id
    action = "ACCEPT"
    
    match_criteria {
        match_type = "DRG_ATTACHMENT_TYPE"
        attachment_type = "IPSEC_TUNNEL"
        drg_attachment_id = oci_core_drg_attachment.test_drg_attachment.id
    }
    priority = 10

}

module "vcn" {
    source = "../../modules/vcn"

    vcn_info = [
        {
        compartment_id  = data.hcp_vault_secrets_app.network_secrets.secrets["main_compartment_id"]
        cidr_block      = var.vcn_cidr_block
        display_name    = "spoke-vcn-ashburn"
    }
    ]
}

module "priv_subnets" {
    source = "../../modules/subnet"
    subnet_info = local.priv_subnets

}

resource "oci_core_route_table" "priv_subnet_rt" {
    compartment_id = data.hcp_vault_secrets_app.network_secrets.secrets["main_compartment_id"]
    vcn_id = module.vcn.vcn_id
    display_name = "Default Route Table for pub-subnet"

    route_rules {
        network_entity_id = module.igw.id["spoke-igw"]
        description = "Forwards packets in pub subnet to IGW."
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }
}