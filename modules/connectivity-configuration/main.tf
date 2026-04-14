resource "azapi_resource" "connectivity_configuration" {
  name      = var.name
  parent_id = var.network_manager_id
  type      = "Microsoft.Network/networkManagers/connectivityConfigurations@2025-05-01"
  body = {
    properties = {
      appliesToGroups = [
        for group in var.applies_to_groups : {
          groupConnectivity = group.group_connectivity
          isGlobal          = group.is_global != null ? (group.is_global ? "True" : "False") : null
          networkGroupId    = group.network_group_id
          useHubGateway     = group.use_hub_gateway != null ? (group.use_hub_gateway ? "True" : "False") : null
        }
      ]
      connectivityCapabilities = var.connectivity_capabilities != null ? {
        connectedGroupAddressOverlap        = var.connectivity_capabilities.connected_group_address_overlap
        connectedGroupPrivateEndpointsScale = var.connectivity_capabilities.connected_group_private_endpoints_scale
        peeringEnforcement                  = var.connectivity_capabilities.peering_enforcement
      } : null
      connectivityTopology  = var.connectivity_topology
      deleteExistingPeering = var.delete_existing_peering != null ? (var.delete_existing_peering ? "True" : "False") : null
      description           = var.description
      hubs = [for hub in(var.connectivity_topology == "HubAndSpoke" ? var.hubs : []) : {
        resourceId   = hub.resource_id
        resourceType = hub.resource_type
      }]
      isGlobal = var.is_global != null ? (var.is_global ? "True" : "False") : null
    }
  }
}
