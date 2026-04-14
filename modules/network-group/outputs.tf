output "name" {
  description = "The resource name."
  value       = azapi_resource.network_group.name
}

output "resource" {
  description = "All attributes of the resource"
  value       = azapi_resource.network_group
}

output "resource_id" {
  description = "The resource ID."
  value       = azapi_resource.network_group.id
}
