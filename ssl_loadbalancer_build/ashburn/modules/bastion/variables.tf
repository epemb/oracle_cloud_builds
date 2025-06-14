variable "bastion_info" {
  description = "Details needed for Certbot deployables"
  type = list(any)
  default = []
}

variable "default_bastion_info" {
  description = "List of maps with Certbot instance info"
  type = object({
    bastion_type                  = string
    compartment_id                = string
    target_subnet_id              = string
    client_cidr_block_allow_list  = list(string)
    name                          = string
  })
  default = {
        bastion_type                  = null
        compartment_id                = null
        target_subnet_id              = null
        client_cidr_block_allow_list  = []
        name                          = ""
  }
}