resource "azapi_resource" "scope_connection" {
  type      = "Microsoft.Network/networkManagers/scopeConnections@2025-05-01"
  parent_id = var.network_manager_id
  name      = var.name

  body = {
    properties = {
      description = var.description
      resourceId  = var.resource_id
      tenantId    = var.tenant_id
    }
  }
}
