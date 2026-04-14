resource "azapi_resource" "network_group" {
  type      = "Microsoft.Network/networkManagers/networkGroups@2025-05-01"
  parent_id = var.network_manager_id
  name      = var.name

  body = {
    properties = {
      description = var.description
      memberType  = var.member_type
    }
  }
}

resource "azapi_resource" "static_member" {
  for_each = { for sm in var.static_members : sm.name => sm }

  type      = "Microsoft.Network/networkManagers/networkGroups/staticMembers@2025-05-01"
  parent_id = azapi_resource.network_group.id
  name      = each.value.name

  body = {
    properties = {
      resourceId = each.value.target_resource_id
    }
  }
}
