variable "tenancy_name" {
    type = string
    default = "delta"
}

variable "vcn_info" {
  description = "List of VCN information"
  type = list(object({
    compartment_id = string
    cidr_block     = string
    display_name   = string
  }))
}

