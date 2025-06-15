locals {
  igw_info = length(var.igw_info) == 0 ? [var.default_igw_info] : [for value in var.igw_info : merge(var.default_igw_info, value)]
}

