resource "oci_core_vcn" "this" {
  for_each = { for k, v in var.vcn_info : k => v }

  compartment_id = each.value.compartment_id
  cidr_block     = each.value.cidr_block
  display_name   = each.value.display_name
}