locals {

priv_subnets = [
    {
        cidr_block                  = var.test1_cidr_block
        compartment_id              = data.hcp_vault_secrets_app.main_compartment_id.secrets["main_compartment_id"]
        vcn_id                      = module.vcn.vcn_id
        display_name                = "test_subnet1"
        prohibit_public_ip_on_vnic  = true

    },

    {   
        cidr_block                  = var.test2_cidr_block        
        compartment_id              = data.hcp_vault_secrets_app.main_compartment_id.secrets["main_compartment_id"]
        vcn_id                      = module.vcn.vcn_id
        display_name                = "test_subnet2"
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