locals {
  certbot_info = length(var.certbot_info) == 0 ? [var.default_certbot_info] : [for value in var.certbot_info : merge(var.default_certbot_info, value)]
}

