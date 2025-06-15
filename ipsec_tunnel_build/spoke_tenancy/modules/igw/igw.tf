resource "oci_core_internet_gateway" "this" {
    for_each = { for igw_info in local.igw_info : igw_info.display_name => igw_info }

    compartment_id = each.value.compartment_id
    vcn_id = each.value.vcn_id
    enabled = true
    display_name = each.value.display_name
}