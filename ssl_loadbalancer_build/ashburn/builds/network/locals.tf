locals {

priv_subnets = [
    {
        cidr_block                  = var.data_cidr_block
        compartment_id              = data.hcp_vault_secrets_app.main_compartment_id.secrets["main_compartment_id"]
        vcn_id                      = module.vcn.vcn_id
        display_name                = "data_subnet"
        prohibit_public_ip_on_vnic  = true

    },

    {   
        cidr_block                  = var.mgmt_cidr_block        
        compartment_id              = data.hcp_vault_secrets_app.main_compartment_id.secrets["main_compartment_id"]
        vcn_id                      = module.vcn.vcn_id
        display_name                = "mgmt_subnet"
        prohibit_public_ip_on_vnic  = true
    }

    
]

pub_subnets = [
    {
        cidr_block                  = var.pub_cidr_block_1
        compartment_id              = data.hcp_vault_secrets_app.main_compartment_id.secrets["main_compartment_id"]
        vcn_id                      = module.vcn.vcn_id
        display_name                = "pub_subnet"
        prohibit_public_ip_on_vnic  = false
    }
]

}