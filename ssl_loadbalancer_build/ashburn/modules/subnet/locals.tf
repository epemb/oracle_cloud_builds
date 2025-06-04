locals {
  subnet_info = length(var.subnet_info) == 0 ? [var.default_subnet_info] : [for value in var.subnet_info : merge(var.default_subnet_info, value)]
}

