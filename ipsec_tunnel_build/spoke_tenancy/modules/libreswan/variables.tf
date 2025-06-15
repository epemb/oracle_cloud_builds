variable "libreswan_info" {
  description = "Details needed for libreswan deployables"
  type = list(any)
  default = []
}

variable "default_libreswan_info" {
  description = "List of maps with libreswan instance info"
  type = object({
    availability_domain = string
    compartment_id      = string
    display_name        = string
    shape               = string
    subnet_id           = string
    source_type         = string
    source_id           = string
    ssh_authorized_keys = string
    user_data           = string
  })
  default = {
      availability_domain = ""
      compartment_id      = ""
      display_name        = null
      shape               = null
      subnet_id           = ""
      source_type         = ""
      source_id           = ""
      ssh_authorized_keys = ""
      user_data           = ""
    }
}