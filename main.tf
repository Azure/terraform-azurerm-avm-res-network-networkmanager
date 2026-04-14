resource "azurerm_network_manager" "this" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  description         = var.description
  scope_accesses      = var.network_manager_scope_accesses
  tags                = var.tags

  dynamic "scope" {
    for_each = [var.network_manager_scope]

    content {
      management_group_ids = scope.value.management_group_ids
      subscription_ids     = scope.value.subscription_ids
    }
  }
  dynamic "timeouts" {
    for_each = var.network_manager_timeouts == null ? [] : [var.network_manager_timeouts]

    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }
}

module "network_groups" {
  source   = "./modules/network-group"
  for_each = coalesce(var.network_groups, {})

  description        = each.value.description
  member_type        = each.value.member_type
  name               = each.value.name
  network_manager_id = azurerm_network_manager.this.id
  static_members     = each.value.static_members
}

module "connectivity_configuration" {
  source   = "./modules/connectivity-configuration"
  for_each = coalesce(var.connectivity_configurations, {})

  applies_to_groups         = each.value.applies_to_groups
  connectivity_capabilities = each.value.connectivity_capabilities
  connectivity_topology     = each.value.connectivity_topology
  description               = each.value.description
  hubs                      = each.value.hubs
  name                      = each.value.name
  network_manager_id        = azurerm_network_manager.this.id
  delete_existing_peering   = each.value.delete_existing_peering
  is_global                 = each.value.is_global

  depends_on = [module.network_groups]
}

module "scope_connection" {
  source   = "./modules/scope-connection"
  for_each = coalesce(var.scope_connections, {})

  description        = each.value.description
  name               = each.value.name
  network_manager_id = azurerm_network_manager.this.id
  resource_id        = each.value.resource_id
  tenant_id          = each.value.tenant_id
}

module "security_admin_configuration" {
  source   = "./modules/security-admin-configuration"
  for_each = coalesce(var.security_admin_configurations, {})

  apply_on_network_intent_policy_based_services  = each.value.apply_on_network_intent_policy_based_services
  description                                    = each.value.description
  name                                           = each.value.name
  network_manager_id                             = azurerm_network_manager.this.id
  rule_collections                               = each.value.rule_collections
  network_group_address_space_aggregation_option = each.value.network_group_address_space_aggregation_option

  depends_on = [module.network_groups]
}

module "routing_configuration" {
  source   = "./modules/routing-configuration"
  for_each = coalesce(var.routing_configurations, {})

  description            = each.value.description
  name                   = each.value.name
  network_manager_id     = azurerm_network_manager.this.id
  rule_collections       = each.value.rule_collections
  route_table_usage_mode = each.value.route_table_usage_mode

  depends_on = [module.network_groups]
}

# required AVM resources interfaces
resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = azurerm_network_manager.this.id
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azurerm_network_manager.this.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                           = each.value.name != null ? each.value.name : "diag-${var.name}"
  target_resource_id             = azurerm_network_manager.this.id
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  log_analytics_destination_type = each.value.log_analytics_destination_type
  log_analytics_workspace_id     = each.value.workspace_resource_id
  partner_solution_id            = each.value.marketplace_partner_resource_id
  storage_account_id             = each.value.storage_account_resource_id

  dynamic "enabled_log" {
    for_each = each.value.log_categories

    content {
      category = enabled_log.value
    }
  }
  dynamic "enabled_log" {
    for_each = each.value.log_groups

    content {
      category_group = enabled_log.value
    }
  }
  dynamic "metric" {
    for_each = each.value.metric_categories

    content {
      category = metric.value
    }
  }
}

