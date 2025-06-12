variable "tenancy_name" {
    type    = string
    default = "delta"
}

variable "vcn_cidr_block" {
    type    = string
    default = "10.0.0.0/16"
}

variable "data_cidr_block" {
    type    = string
    default = "10.0.2.0/24"
}

variable "mgmt_cidr_block" {
    type    = string
    default = "10.0.3.0/24"
}

variable "pub_cidr_block_1" {
    type = string
    default = "10.0.1.0/24"
}