terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71, < 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# This picks a random region from the list of regions.
resource "random_integer" "region_index" {
  max = length(local.azure_regions) - 1
  min = 0
}

data "azurerm_subscription" "current" {}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = local.azure_regions[random_integer.region_index.result]
  name     = module.naming.resource_group.name_unique
}

resource "azurerm_virtual_network" "this" {
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  name                = module.naming.virtual_network.name
  resource_group_name = azurerm_resource_group.this.name
}

# This is the module call
module "network_manager" {
  source = "../../"
  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  # ...
  enable_telemetry               = var.enable_telemetry
  name                           = "network-manager"
  resource_group_name            = azurerm_resource_group.this.name
  location                       = azurerm_resource_group.this.location
  network_manager_scope_accesses = ["Connectivity", "SecurityAdmin"]
  network_manager_scope = {
    subscription_ids = ["/subscriptions/${data.azurerm_subscription.current.subscription_id}"]
  }
  network_manager_network_groups = {
    "network-group-1" = {
      name = "network-group-1"
      static_members = [
        {
          name                      = "static-member-1"
          target_virtual_network_id = azurerm_virtual_network.this.id
        }
      ]
    }
  }
}
