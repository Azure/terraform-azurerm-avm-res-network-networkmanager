output "name" {
  description = "The resource name."
  value       = azapi_resource.connectivity_configuration.name
}

output "resource" {
  description = "All attributes of the resource"
  value       = azapi_resource.connectivity_configuration
}

output "resource_id" {
  description = "The resource ID."
  value       = azapi_resource.connectivity_configuration.id
}
