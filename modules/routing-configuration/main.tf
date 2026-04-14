resource "azapi_resource" "routing_configuration" {
  type      = "Microsoft.Network/networkManagers/routingConfigurations@2025-05-01"
  parent_id = var.network_manager_id
  name      = var.name

  body = {
    properties = {
      description         = var.description
      routeTableUsageMode = var.route_table_usage_mode
    }
  }
}

resource "azapi_resource" "rule_collections" {
  for_each = var.rule_collections
  type     = "Microsoft.Network/networkManagers/routingConfigurations/ruleCollections@2025-05-01"

  parent_id = azapi_resource.routing_configuration.id
  name      = each.value.name

  body = {
    properties = {
      description                = each.value.description
      appliesTo                  = each.value.applies_to
      disableBgpRoutePropagation = each.value.disable_bgp_route_propagation
    }
  }
}

resource "azapi_resource" "rules" {
  for_each = { for rc in var.rule_collections : rc.name => rc.rules... }
  type     = "Microsoft.Network/networkManagers/routingConfigurations/ruleCollections/rules@2025-05-01"

  parent_id = azapi_resource.rule_collections[each.key].id
  name      = each.value.name

  body = {
    properties = {
      description = each.value.description
      destination = each.value.destination
      nextHop     = each.value.next_hop
    }
  }
}
