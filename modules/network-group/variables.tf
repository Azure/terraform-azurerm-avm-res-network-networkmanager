variable "network_manager_id" {
  type        = string
  description = <<DESCRIPTION
  (Required) The ID of the Network Manager.
  DESCRIPTION
  nullable    = false
}

variable "name" {
  type        = string
  description = <<DESCRIPTION
  (Required) The name of the network group.
  DESCRIPTION
  validation {
    condition     = length(var.name) <= 64
    error_message = "The Name can be up to 64 characters in length."
  }
  nullable = false
}

variable "description" {
  type        = string
  description = <<DESCRIPTION
  (Optional) The description of the network group.
  DESCRIPTION
  validation {
    condition     = length(var.description) <= 500
    error_message = "The Description can be up to 500 characters in length."
  }
}

variable "member_type" {
  type        = string
  description = <<DESCRIPTION
  (Optional) The type of members in the network group. Possible values are `VirtualNetwork` and `Subnet`.
  DESCRIPTION
  validation {
    condition     = var.member_type == null || contains(["VirtualNetwork", "Subnet"], var.member_type)
    error_message = "The Member Type must be either 'VirtualNetwork' or 'Subnet'."
  }
}

variable "static_members" {
  type = list(object({
    name               = string
    target_resource_id = string
  }))
  description = <<DESCRIPTION
  (Optional) A list of static members to be included in the network group. Each static member requires a name and a target resource ID.
  DESCRIPTION
}
