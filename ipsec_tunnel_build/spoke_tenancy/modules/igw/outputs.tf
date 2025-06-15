output "id" {
  description = "Map of Internet Gateway IDs keyed by display name"
  value = { for k, igw in oci_core_internet_gateway.this : k => igw.id }
}