# TODO: insert outputs here.

# Module owners should include the full resource via a 'resource' output
# https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tffr2---category-outputs---additional-terraform-outputs
output "network_manager" {
  value       = azurerm_network_manager.this
  description = "This is the full output for the resource."
}
