# Data source used to pull in the main_compartment_id secret from HCP Vault Secrets
data "hcp_vault_secrets_app" "main_compartment_id" {
    app_name = "oracle-tenancy-secrets"
}

module "vcn" {
    source = "../../modules/vcn"

    vcn_info = [
        {
        compartment_id  = data.hcp_vault_secrets_app.main_compartment_id.secrets["main_compartment_id"]
        cidr_block      = var.vcn_cidr_block
        display_name    = "hub-vcn-ashburn"
    }
    ]

}

module "pub_subnets" {
    source = "../../modules/subnet"
    subnet_info = local.pub_subnets

}

module "priv_subnets" {
    source = "../../modules/subnet"
    subnet_info = local.priv_subnets

}

resource "oci_core_route_table" "mgmt_subnet_rt" {
    compartment_id = data.hcp_vault_secrets_app.main_compartment_id.secrets["main_compartment_id"]
    vcn_id = module.vcn.vcn_id
    display_name = "Default Route Table for mgmt-subnet"

    route_rules {
        network_entity_id = oci_load_balancer_load_balancer.pub_lb.id
        description = "Forwards packets in mgmt subnet to Public load balancer."
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }
}

resource "oci_core_route_table_attachment" "test_route_table_attachment" {
  subnet_id = module.priv_subnets.id["mgmt_subnet"]
  route_table_id = oci_core_route_table.mgmt_subnet_rt.id
}

resource "oci_load_balancer_load_balancer" "pub_lb" {
    compartment_id = data.hcp_vault_secrets_app.main_compartment_id.secrets["main_compartment_id"]
    display_name = "pub_lb"
    shape = "10Mbps"
    subnet_ids = [module.pub_subnets.id["pub_subnet"]]
    is_private = false

}

resource "oci_dns_zone" "public_zone" {
  compartment_id = data.hcp_vault_secrets_app.main_compartment_id.secrets["main_compartment_id"]
  name          = "treadsec.com"
  zone_type     = "PRIMARY"

}

resource "oci_dns_rrset" "test_rrset" {
    domain = "treadsec.com"
    rtype = "A"
    zone_name_or_id = oci_dns_zone.public_zone.id

    items {
        domain = "treadsec.com"
        rdata = oci_load_balancer_load_balancer.pub_lb.ip_address_details[0].ip_address
        rtype = "A"
        ttl = 3600
    }
}

resource "oci_core_nat_gateway" "hub_ngw" {
    compartment_id = data.hcp_vault_secrets_app.main_compartment_id.secrets["main_compartment_id"]
    vcn_id = module.vcn.vcn_id
    display_name = "hub_ngw"
}