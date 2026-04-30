locals {
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
}

# Resolve `network_group_key` references (map keys of `var.network_groups`) into the actual
# network group resource IDs that the submodules expect via their `network_group_id` inputs.
locals {
  connectivity_configurations_resolved = {
    for cfg_key, cfg in var.connectivity_configurations : cfg_key => merge(cfg, {
      applies_to_groups = [
        for group in cfg.applies_to_groups : {
          group_connectivity = group.group_connectivity
          is_global          = group.is_global
          use_hub_gateway    = group.use_hub_gateway
          network_group_id   = module.network_groups[group.network_group_key].resource_id
        }
      ]
    })
  }
  routing_configurations_resolved = {
    for cfg_key, cfg in var.routing_configurations : cfg_key => merge(cfg, {
      rule_collections = {
        for rc_key, rc in cfg.rule_collections : rc_key => merge(rc, {
          applies_to = [
            for group in rc.applies_to : {
              network_group_id = module.network_groups[group.network_group_key].resource_id
            }
          ]
        })
      }
    })
  }
  security_admin_configurations_resolved = {
    for cfg_key, cfg in var.security_admin_configurations : cfg_key => merge(cfg, {
      rule_collections = {
        for rc_key, rc in cfg.rule_collections : rc_key => merge(rc, {
          applies_to_groups = [
            for group in rc.applies_to_groups : {
              network_group_id = module.network_groups[group.network_group_key].resource_id
            }
          ]
        })
      }
    })
  }
}
