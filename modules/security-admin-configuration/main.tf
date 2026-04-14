resource "azapi_resource" "security_admin_configuration" {
  name      = var.name
  parent_id = var.network_manager_id
  type      = "Microsoft.Network/networkManagers/securityAdminConfigurations@2025-05-01"
  body = {
    properties = {
      description                               = var.description
      applyOnNetworkIntentPolicyBasedServices   = var.apply_on_network_intent_policy_based_services
      networkGroupAddressSpaceAggregationOption = var.network_group_address_space_aggregation_option
    }
  }
}

resource "azapi_resource" "rule_collections" {
  for_each = var.rule_collections

  name      = each.value.name
  parent_id = azapi_resource.security_admin_configuration.id
  type      = "Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections@2025-05-01"
  body = {
    properties = {
      description     = each.value.description
      appliesToGroups = each.value.applies_to_groups
    }
  }
}

resource "azapi_resource" "rules" {
  for_each = { for rc in var.rule_collections : rc.name => rc.rules... }

  name      = each.value.name
  parent_id = azapi_resource.rule_collections[each.key].id
  type      = "Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules@2025-05-01"
  body = {
    kind = "Custom"
    properties = {
      description           = each.value.description
      access                = each.value.access
      destinationPortRanges = each.value.destination_port_ranges
      destinations          = each.value.destinations
      direction             = each.value.direction
      priority              = each.value.priority
      protocol              = each.value.protocol
      sourcePortRanges      = each.value.source_port_ranges
      sources               = each.value.sources
    }
  }
}
