variable "name" {
  type        = string
  description = <<DESCRIPTION
  (Required) The name of the Scope Connection. The name must be between 1 and 64 characters, and can contain letters, numbers, underscores, periods, and hyphens. The name must start with a letter or a number, and end with a letter, a number, or an underscore.
  DESCRIPTION
  nullable    = false

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "The name must be between 1 and 64 characters in length."
  }
}

variable "network_manager_id" {
  type        = string
  description = <<DESCRIPTION
  (Required) The ID of the Network Manager to which this Scope Connection belongs.
  DESCRIPTION
  nullable    = false
}

variable "resource_id" {
  type        = string
  description = <<DESCRIPTION
  (Required) The ID of the Subscription or Management Group to which the Network Manager will connect.
  DESCRIPTION
  nullable    = false
}

variable "tenant_id" {
  type        = string
  description = <<DESCRIPTION
  (Required) The tenant ID of the Subscription or Management Group to which the Network Manager will connect.
  DESCRIPTION
  nullable    = false
}

variable "description" {
  type        = string
  default     = ""
  description = <<DESCRIPTION
  (Optional) The description of the Scope Connection.
  DESCRIPTION
  nullable    = false

  validation {
    condition     = length(var.description) <= 500
    error_message = "The description must be 500 characters or less."
  }
}
