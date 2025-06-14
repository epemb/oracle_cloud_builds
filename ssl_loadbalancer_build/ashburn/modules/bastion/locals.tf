locals {
  bastion_info = length(var.bastion_info) == 0 ? [var.default_bastion_info] : [for value in var.bastion_info : merge(var.default_bastion_info, value)]
}