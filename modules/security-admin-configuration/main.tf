resource "azapi_resource" "security_admin_configuration" {
  name      = var.name
  parent_id = var.network_manager_id
  type      = "Microsoft.Network/networkManagers/securityAdminConfigurations@2025-05-01"
  body = {
    properties = {
      description                               = var.description
      applyOnNetworkIntentPolicyBasedServices   = var.apply_on_network_intent_policy_based_services
      networkGroupAddressSpaceAggregationOption = coalesce(var.network_group_address_space_aggregation_option, "None")
    }
  }
}

resource "azapi_resource" "rule_collections" {
  for_each = coalesce(var.rule_collections, {})

  name      = each.value.name
  parent_id = azapi_resource.security_admin_configuration.id
  type      = "Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections@2025-05-01"
  body = {
    properties = {
      description = each.value.description == null ? "" : each.value.description
      appliesToGroups = [for group in each.value.applies_to_groups : {
        networkGroupId = group.network_group_id
      }]
    }
  }
}

resource "azapi_resource" "rules" {
  for_each = local.merged_rules

  name      = each.value.rule.name
  parent_id = azapi_resource.rule_collections[each.value.rule_collection_key].id
  type      = "Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules@2025-05-01"
  body = {
    kind = "Custom"
    properties = {
      description           = each.value.rule.description == null ? "" : each.value.rule.description
      access                = each.value.rule.access
      destinationPortRanges = coalesce(each.value.rule.destination_port_ranges, [])
      destinations = [for destination in coalesce(each.value.rule.destinations, []) : {
        addressPrefix     = destination.address_prefix
        addressPrefixType = destination.address_prefix_type
      }]
      direction        = each.value.rule.direction
      priority         = each.value.rule.priority
      protocol         = each.value.rule.protocol
      sourcePortRanges = coalesce(each.value.rule.source_port_ranges, [])
      sources = [for source in coalesce(each.value.rule.sources, []) : {
        addressPrefix     = source.address_prefix
        addressPrefixType = source.address_prefix_type
      }]
    }
  }
}
