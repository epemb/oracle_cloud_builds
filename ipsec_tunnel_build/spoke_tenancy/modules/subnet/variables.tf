variable "subnet_info" {
  description = "Details needed for subnet deployables"
  type    = list(any)
  default = []
}


variable "default_subnet_info" {
  description = "Default subnet info used when none exists. Merged in locals.tf for variable reference"
  type = object({
    compartment_id              = string
    cidr_block                  = string
    vcn_id                      = string
    display_name                = string
    prohibit_public_ip_on_vnic  = string
  })
  default     = {
    compartment_id              = ""
    cidr_block                  = ""
    vcn_id                      = ""
    display_name                = null
    prohibit_public_ip_on_vnic  = null
  }
}