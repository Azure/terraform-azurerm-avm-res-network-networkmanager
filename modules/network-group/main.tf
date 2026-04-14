resource "azapi_resource" "network_group" {
  name      = var.name
  parent_id = var.network_manager_id
  type      = "Microsoft.Network/networkManagers/networkGroups@2025-05-01"
  body = {
    properties = {
      description = var.description
      memberType  = var.member_type
    }
  }
}

resource "azapi_resource" "static_member" {
  for_each = { for sm in var.static_members : sm.name => sm }

  name      = each.value.name
  parent_id = azapi_resource.network_group.id
  type      = "Microsoft.Network/networkManagers/networkGroups/staticMembers@2025-05-01"
  body = {
    properties = {
      resourceId = each.value.target_resource_id
    }
  }
}
