resource "oci_bastion_bastion" "this" {
  for_each = { for bastion_info in local.bastion_info : bastion_info.name => bastion_info }

    name = each.value.name
    bastion_type = "standard"
    compartment_id = each.value.compartment_id
    target_subnet_id = each.value.target_subnet_id
    client_cidr_block_allow_list = each.value.client_cidr_block_allow_list
}