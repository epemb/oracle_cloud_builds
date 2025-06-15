locals {
  libreswan_info = length(var.libreswan_info) == 0 ? [var.default_libreswan_info] : [for value in var.libreswan_info : merge(var.default_libreswan_info, value)]
}

