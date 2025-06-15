variable "igw_info" {
  description = "Details needed for subnet deployables"
  type    = list(any)
  default = []
}


variable "default_igw_info" {
  description = "Default subnet info used when none exists. Merged in locals.tf for variable reference"
  type = object({
    compartment_id              = string
    vcn_id                      = string
    display_name                = string
  })
  default     = {
    compartment_id              = ""
    vcn_id                      = ""
    display_name                = null
  }
}