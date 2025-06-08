# Data source used to pull in the main_compartment_id secret from HCP Vault Secrets
data "hcp_vault_secrets_app" "main_compartment_id" {
    app_name = "oracle-tenancy-secrets"
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = data.hcp_vault_secrets_app.main_compartment_id.secrets["main_compartment_id"]
}

data "oci_core_images" "oracle_linux" {
  compartment_id           = data.hcp_vault_secrets_app.main_compartment_id.secrets["main_compartment_id"]
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = "VM.Standard.E2.1.Micro"
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

# Deploys Certbot instance that will handle generating ssl key for domain
resource "oci_core_instance" "certbot_instance" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = data.hcp_vault_secrets_app.main_compartment_id.secrets["main_compartment_id"]
  display_name        = "Certbot"
  shape               = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id        = module.pub_subnets.id["pub_subnet"]
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oracle_linux.images[0].id
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.certbot.public_key_openssh
  }
}

# Generates a pub/priv key pair for Certbot instance.
resource "tls_private_key" "certbot" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "certbot_private_key" {
  content         = tls_private_key.certbot.private_key_pem
  filename        = "/Users/epemb/Programming/Priv_keys/cerbot_keys/certbot_id_rsa"
  file_permission = "0600"
}

resource "oci_core_nat_gateway" "test_nat_gateway" {
    compartment_id = data.hcp_vault_secrets_app.main_compartment_id
    vcn_id = oci_core_vcn.test_vcn.id
    display_name = "test_ngw"
    route_table_id = oci_core_route_table.test_route_table.id
}