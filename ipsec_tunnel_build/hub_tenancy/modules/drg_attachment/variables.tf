variable "drg_attachment_info" {
  description = "Details needed for subnet deployables"
  type    = list(any)
  default = []
}


variable "default_drg_attachment_info" {
  description = "Default subnet info used when none exists. Merged in locals.tf for variable reference"
  type = object({
    drg_id                      = string
    drg_route_table_id          = string
    display_name                = string
    id                          = string
    type                        = string
    route_table_id              = string
  })
  default = {
    drg_id                      = ""
    drg_route_table_id          = null
    display_name                = null
    id                          = ""
    type                        = ""
    route_table_id              = null
  }
}