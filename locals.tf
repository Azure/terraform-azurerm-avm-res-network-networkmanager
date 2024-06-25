# TODO: insert locals here.
locals {
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
}


# Restructure locals

locals {
  # The following local creates a list of static members for each network group.
  network_groups_static_members = flatten([
    for network_group_key, network_group in var.network_manager_network_groups :
    [
      for static_member in network_group.static_members :
      {
        network_group_key         = network_group_key
        static_member_name        = static_member.name
        target_virtual_network_id = static_member.target_virtual_network_id
      }
    ]
  ])
}
