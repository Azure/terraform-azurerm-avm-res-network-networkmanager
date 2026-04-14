variable "description" {
  type        = string
  description = <<DESCRIPTION
  (Optional) The description of the Routing Configuration. The description must be between 0 and 255 characters, and can contain letters, numbers, underscores, periods, and hyphens. The description must start with a letter or a number, and end with a letter, a number, or an underscore.
  DESCRIPTION

  validation {
    condition     = length(var.description) <= 500
    error_message = "The description must be 500 characters or less."
  }
}

variable "name" {
  type        = string
  description = <<DESCRIPTION
  (Required) The name of the Routing Configuration. The name must be between 1 and 80 characters, and can contain letters, numbers, underscores, periods, and hyphens. The name must start with a letter or a number, and end with a letter, a number, or an underscore.
  DESCRIPTION
  nullable    = false

  validation {
    condition     = length(var.name) <= 64
    error_message = "The name must be 64 characters or less."
  }
}

variable "network_manager_id" {
  type        = string
  description = <<DESCRIPTION
  (Required) The ID of the Network Manager to which this Routing Configuration belongs.
  DESCRIPTION
  nullable    = false
}

variable "rule_collections" {
  type = list(object({
    name        = string
    description = optional(string, null)
    applies_to = list(object({
      network_group_resource_id = string
    }))
    disable_bgp_route_propagation = optional(bool, null)
    rules = list(object({
      name        = string
      description = optional(string, null)
      destination = object({
        type                = string
        destination_address = string
      })
      next_hop = object({
        next_hop_type    = string
        next_hop_address = optional(string, null)
      })
    }))
  }))
  description = <<DESCRIPTION
  (Optional) A list of rule collections to create on the routing configuration.
  - `name` - (Required) The name of the rule collection.
  - `description` - (Optional) The description of the rule collection.
  - `applies_to` - (Required) A list of network groups that the rule collection applies to.
    - `network_group_resource_id` - (Required) The resource ID of the network group that the rule collection applies to.
  - `disable_bgp_route_propagation` - (Optional) A boolean value indicating whether or not to disable BGP route propagation for this rule collection. Defaults to false.
  - `rules` - (Required) A list of rules to create on the rule collection.
    - `name` - (Required) The name of the rule.
    - `description` - (Optional) The description of the rule.
    - `destination` - (Required) The destination for the route.
      - `type` - (Required) The type of destination. Possible values are `AddressPrefix` and `ServiceTag`.
      - `destination_address` - (Required) The destination address. If the destination type is AddressPrefix, then this must be a valid CIDR notation. If the destination type is ServiceTag, then this must be a valid service tag.
    - `next_hop` - (Required) The next hop for the route.
      - `next_hop_type` - (Required) The type of next hop. Possible values are `VirtualAppliance`, `Internet`, `VirtualNetworkGateway`, `VnetLocal`, and `NoNextHop`.
      - `next_hop_address` - (Conditional) The next hop address. This is only applicable if the next hop type is VirtualAppliance, in which case this must be a valid IP address.
  DESCRIPTION
}

variable "route_table_usage_mode" {
  type        = string
  default     = "ManagedOnly"
  description = <<DESCRIPTION
  (Optional) The route table usage mode for the Routing Configuration. Possible values are `ManagedOnly` and `UseExisting`. If not specified, the default value is `ManagedOnly`.
  DESCRIPTION
}
