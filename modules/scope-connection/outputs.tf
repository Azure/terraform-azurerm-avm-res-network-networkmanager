output "name" {
  description = "The resource name."
  value       = azapi_resource.scope_connection.name
}

output "resource" {
  description = "All attributes of the resource"
  value       = azapi_resource.scope_connection
}

output "resource_id" {
  description = "The resource ID."
  value       = azapi_resource.scope_connection.id
}
