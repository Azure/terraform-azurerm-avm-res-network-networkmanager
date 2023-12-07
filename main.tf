/*data "azurerm_resource_group" "parent" {
  count = var.location == null ? 1 : 0
  name  = var.resource_group_name
}
*/

data "azurerm_subscription" "current" {
}

resource "azurerm_network_manager" "this" {
  name                = var.name # calling code must supply the name
  resource_group_name = var.resource_group_name
  location            = var.location
  scope {
    subscription_ids = [data.azurerm_subscription.current.id]
  }
  scope_accesses = var.scope_accesses
}

# required AVM resources interfaces
resource "azurerm_management_lock" "this" {
  count      = var.lock.kind != "None" ? 1 : 0
  name       = coalesce(var.lock.name, "lock-${var.name}")
  scope      = azurerm_network_manager.this.id
  lock_level = var.lock.kind
}

resource "azurerm_role_assignment" "this" {
  for_each                               = var.role_assignments
  scope                                  = azurerm_network_manager.this.id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  principal_id                           = each.value.principal_id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
}
