resource "azapi_resource" "scope_connection" {
  name      = var.name
  parent_id = var.network_manager_id
  type      = "Microsoft.Network/networkManagers/scopeConnections@2025-05-01"
  body = {
    properties = {
      description = var.description
      resourceId  = var.resource_id
      tenantId    = var.tenant_id
    }
  }
}
