# Deploys libreswan instance that will handle generating ssl key for domain
resource "oci_core_instance" "this" {
  for_each = { for libreswan_info in local.libreswan_info : libreswan_info.display_name => libreswan_info }

  availability_domain = each.value.availability_domain
  compartment_id      = each.value.compartment_id
  display_name        = each.value.display_name
  shape               = each.value.shape

  create_vnic_details {
    subnet_id        = each.value.subnet_id
    assign_public_ip = false
  }

  source_details {
    source_type = each.value.source_type
    source_id   = each.value.source_id
  }

  metadata = {
    ssh_authorized_keys = each.value.ssh_authorized_keys
    user_data           = each.value.user_data
  }
}