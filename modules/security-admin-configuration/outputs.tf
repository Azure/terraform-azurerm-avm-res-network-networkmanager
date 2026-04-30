output "name" {
  description = "The resource name."
  value       = azapi_resource.security_admin_configuration.name
}

output "resource" {
  description = "All attributes of the resource"
  value       = azapi_resource.security_admin_configuration
}

output "resource_id" {
  description = "The resource ID."
  value       = azapi_resource.security_admin_configuration.id
}
