resource "oci_core_drg_attachment" "test_drg_attachment" {
    for_each = { for drg_attachment_info in local.drg_attachment_info : drg_attachment_info.display_name => drg_attachment_info }

    drg_id = each.value.drg_id
    display_name = each.value.display_name
    drg_route_table_id = each.value.drg_route_table_id

    network_details {
        id = each.value.id
        type = each.value.type
        route_table_id = each.value.route_table_id
    }
}