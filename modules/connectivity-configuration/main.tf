resource "azapi_resource" "connectivity_configuration" {
  type      = "Microsoft.Network/networkManagers/connectivityConfigurations@2025-05-01"
  parent_id = var.network_manager_id
  name      = var.name

  body = {
    properties = {
      appliesToGroups = [
        for group in var.applies_to_groups : {
          groupConnectivity = group.group_connectivity
          isGlobal          = group.is_global
          networkGroupId    = group.network_group_resource_id
          useHubGateway     = group.use_hub_gateway
        }
      ]
      connectivityCapabilities = var.connectivity_capabilities
      connectivityTopology     = var.connectivity_topology
      deleteExistingPeering    = var.delete_existing_peering
      description              = var.description
      hubs                     = var.connectivity_topology == "HubAndSpoke" ? var.hubs : []
      isGlobal                 = var.is_global
    }
  }
}
