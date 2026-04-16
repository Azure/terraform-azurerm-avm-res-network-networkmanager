variable "description" {
  type        = string
  default     = null
  description = <<DESCRIPTION
  (Optional) The description of the network group.
  DESCRIPTION

  validation {
    condition     = var.description == null ? true : length(var.description) <= 500
    error_message = "The Description can be up to 500 characters in length."
  }
}

variable "member_type" {
  type        = string
  description = <<DESCRIPTION
  (Optional) The type of members in the network group. Possible values are `VirtualNetwork` and `Subnet`.
  DESCRIPTION
  default     = "VirtualNetwork"
  nullable    = false

  validation {
    condition     = contains(["VirtualNetwork", "Subnet"], var.member_type)
    error_message = "The Member Type must be either 'VirtualNetwork' or 'Subnet'."
  }
}

variable "name" {
  type        = string
  description = <<DESCRIPTION
  (Required) The name of the network group.
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

variable "static_members" {
  type = list(object({
    name               = string
    target_resource_id = string
  }))
  default     = []
  description = <<DESCRIPTION
  (Optional) A list of static members to be included in the network group. Each static member requires a name and a target resource ID.
  DESCRIPTION
  nullable    = false
}
