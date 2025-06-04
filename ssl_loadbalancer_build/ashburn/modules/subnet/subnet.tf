resource "oci_core_subnet" "this" { 
    for_each = { for subnet_info in local.subnet_info : subnet_info.display_name => subnet_info }

    cidr_block                  = each.value.cidr_block
    compartment_id              = each.value.compartment_id
    vcn_id                      = each.value.vcn_id
    display_name                = each.value.display_name
    prohibit_public_ip_on_vnic  = each.value.prohibit_public_ip_on_vnic

}