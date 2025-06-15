output "id" {
  description = "Provides id attribute for subnets"
  value       = {for i in local.subnet_info[*].display_name : i => oci_core_subnet.this[i].id}
}