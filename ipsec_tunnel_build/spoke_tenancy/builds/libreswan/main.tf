data "hcp_vault_secrets_app" "libreswan_secrets" {
    app_name = "oracle-tenancy-secrets"
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = data.hcp_vault_secrets_app.libreswan_secrets.secrets["spoke_main_compartment_id"]
}

data "oci_core_images" "oracle_linux" {
  compartment_id           = data.hcp_vault_secrets_app.libreswan_secrets.secrets["spoke_main_compartment_id"]
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = "VM.Standard.E2.1.Micro"
}

# Accesses the Public Subnet resource to reference subnet in Libreswan instance
data "oci_core_subnets" "pub_subnet" {
    compartment_id = data.hcp_vault_secrets_app.libreswan_secrets.secrets["spoke_main_compartment_id"]
    display_name = "spoke-pub-subnet"
}

module "libreswan" {
  source = "../../modules/libreswan"

  libreswan_info = [
    {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      compartment_id      = data.hcp_vault_secrets_app.libreswan_secrets.secrets["spoke_main_compartment_id"]
      display_name        = "Libreswan"
      shape               = "VM.Standard.E2.1"
      subnet_id           = data.oci_core_subnets.pub_subnet.subnets[0].id
      source_type         = "image"
      source_id           = data.oci_core_images.oracle_linux.images[0].id
      ssh_authorized_keys = tls_private_key.libreswan.public_key_openssh
      user_data           = base64encode(file("${path.module}/startup.sh"))

    }
  ]
}

# Generates a pub/priv key pair for Certbot instance.
resource "tls_private_key" "libreswan" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Saves private key locally in filename path
resource "local_file" "libreswan_private_key" {
  content         = tls_private_key.libreswan.private_key_pem
  filename        = "/Users/epemb/Programming/Priv_keys/libreswan_keys/libreswan_id_rsa"
  file_permission = "0600"
}