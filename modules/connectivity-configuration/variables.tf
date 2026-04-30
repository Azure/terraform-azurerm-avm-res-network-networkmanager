variable "applies_to_groups" {
  type = list(object({
    group_connectivity = string
    is_global          = optional(bool, false)
    network_group_id   = string
    use_hub_gateway    = optional(bool, false)
  }))
  description = <<DESCRIPTION
  (Required) A list of network groups that the connectivity configuration applies to.
  - `group_connectivity` - (Required) The type of connectivity for the group. `DirectlyConnected` and `None`.
  - `is_global` - (Optional) A boolean value indicating whether the connectivity configuration applies to all network groups in the Network Manager. If set to true, then the connectivity configuration applies to all network groups and the `network_group_id` property is ignored. Defaults to false.
  - `network_group_id` - (Required) The resource ID of the network group that the connectivity configuration applies to. This property is required if `is_global` is set to false.
  - `use_hub_gateway` - (Optional) A boolean value indicating whether or not to use a hub gateway for this connectivity configuration. This is only applicable if the topology is set to `HubAndSpoke`. Defaults to false.
  DESCRIPTION
  nullable    = false

  validation {
    condition     = alltrue([for group in var.applies_to_groups : contains(["DirectlyConnected", "None"], group.group_connectivity)])
    error_message = "Each group's connectivity must be either 'DirectlyConnected' or 'None'."
  }
}

variable "connectivity_topology" {
  type        = string
  description = <<DESCRIPTION
  (Required) The connectivity topology of the connectivity configuration. Possible values are `HubAndSpoke` and `Mesh`.
  DESCRIPTION
  nullable    = false

  validation {
    condition     = contains(["HubAndSpoke", "Mesh"], var.connectivity_topology)
    error_message = "The Connectivity Topology must be either 'HubAndSpoke' or 'Mesh'."
  }
}

variable "name" {
  type        = string
  description = <<DESCRIPTION
  (Required) The name of the connectivity configuration.
  DESCRIPTION
  nullable    = false

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "The Name must be between 1 and 64 characters in length."
  }
}

variable "network_manager_id" {
  type        = string
  description = <<DESCRIPTION
  (Required) The ID of the Network Manager.
  DESCRIPTION
  nullable    = false
}

variable "connectivity_capabilities" {
  type = object({
    connected_group_address_overlap         = string
    connected_group_private_endpoints_scale = string
    peering_enforcement                     = string
  })
  default     = null
  description = <<DESCRIPTION
  (Optional) A set of connectivity capabilities for the connectivity configuration.
  - `connected_group_address_overlap` - (Optional) The connectivity configuration's capability for connected group address overlap. Possible values are `Allowed` and `Disallowed`.
  - `connected_group_private_endpoints_scale` - (Optional) The connectivity configuration's capability for connected group private endpoint scale. Possible values are `HighScale` and `Standard`.
  - `peering_enforcement` - (Optional) The connectivity configuration's capability for peering enforcement. Possible values are `Enforced` and `Unenforced`.
  DESCRIPTION
}

variable "delete_existing_peering" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
  (Optional) A boolean value indicating whether to delete existing peering connections. Defaults to false.
  DESCRIPTION
  nullable    = false
}

variable "description" {
  type        = string
  default     = null
  description = <<DESCRIPTION
  (Optional) The description of the connectivity configuration.
  DESCRIPTION

  validation {
    condition     = var.description == null ? true : length(var.description) <= 500
    error_message = "The Description can be up to 500 characters in length."
  }
}

variable "hubs" {
  type = list(object({
    resource_id   = string
    resource_type = string
  }))
  default     = []
  description = <<DESCRIPTION
  (Optional) A list of hubs for the connectivity configuration. This is only applicable if the topology is set to `HubAndSpoke`.
  - `resource_id` - (Required) The resource ID of the hub.
  - `resource_type` - (Required) The resource type of the hub. Possible values are `Microsoft.Network/virtualNetworks`.
  DESCRIPTION
  nullable    = false

  validation {
    condition     = var.connectivity_topology == "HubAndSpoke" || length(var.hubs) == 0
    error_message = "'Hubs' are only applicable if topology is set to 'HubAndSpoke'."
  }
}

variable "is_global" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
  (Optional) A boolean value indicating whether the connectivity configuration applies to all network groups in the Network Manager. Defaults to false.
  DESCRIPTION
  nullable    = false
}
