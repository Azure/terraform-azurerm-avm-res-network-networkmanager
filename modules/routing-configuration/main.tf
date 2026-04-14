resource "azapi_resource" "routing_configuration" {
  name      = var.name
  parent_id = var.network_manager_id
  type      = "Microsoft.Network/networkManagers/routingConfigurations@2025-05-01"
  body = {
    properties = {
      description         = var.description
      routeTableUsageMode = var.route_table_usage_mode
    }
  }
}

resource "azapi_resource" "rule_collections" {
  for_each = coalesce(var.rule_collections, {})

  name      = each.value.name
  parent_id = azapi_resource.routing_configuration.id
  type      = "Microsoft.Network/networkManagers/routingConfigurations/ruleCollections@2025-05-01"
  body = {
    properties = {
      description = each.value.description
      appliesTo = [for group in each.value.applies_to : {
        networkGroupId = group.network_group_id
      }]
      disableBgpRoutePropagation = each.value.disable_bgp_route_propagation != null ? (each.value.disable_bgp_route_propagation ? "True" : "False") : null
    }
  }
}

resource "azapi_resource" "rules" {
  for_each = local.merged_rules

  name      = each.value.rule.name
  parent_id = azapi_resource.rule_collections[each.value.rule_collection_key].id
  type      = "Microsoft.Network/networkManagers/routingConfigurations/ruleCollections/rules@2025-05-01"
  body = {
    properties = {
      description = each.value.rule.description
      destination = {
        destinationAddress = each.value.rule.destination.destination_address
        type               = each.value.rule.destination.type
      }
      nextHop = {
        nextHopAddress = each.value.rule.next_hop.next_hop_address
        nextHopType    = each.value.rule.next_hop.next_hop_type
      }
    }
  }
}
