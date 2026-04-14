output "name" {
  description = "The name of the Network Manager."
  value       = azurerm_network_manager.this.name
}

output "resource" {
  description = "The full output for the Network Manager."
  value       = azurerm_network_manager.this
}

output "resource_id" {
  description = "The ID of the Network Manager."
  value       = azurerm_network_manager.this.id
}
