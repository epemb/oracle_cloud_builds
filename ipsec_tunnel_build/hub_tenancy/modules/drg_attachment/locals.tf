locals {
    drg_attachment_info = length(var.drg_attachment_info) == 0 ? [var.default_drg_attachment_info] : [for value in var.drg_attachment_info : merge(var.default_drg_attachment_info, value)]
}