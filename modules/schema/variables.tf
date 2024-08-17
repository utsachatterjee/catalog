variable "schemas" {
  type = list(object({
    name          = string
    catalog_name  = string
    comment       = optional(string)
    force_destroy = bool
    grants = list(object({
      principal  = string
      privileges = list(string)
    }))
  }))
  description = "the schema definition object"
  nullable    = false

  validation {
    condition     = !contains(flatten([for k, v in var.schemas : [for i, s in v.grants : strcontains(s.principal, "@")]]), true)
    error_message = "The principal value in the 'grants' section must be a group. It can't be an user email."
  }

  validation {
    condition     = !contains(flatten([for k, v in var.schemas : [for i, s in v.grants : contains(s.privileges, "ALL_PRIVILEGES")]]), true)
    error_message = "'ALL_PRIVILEGES' is not allowd in the privileges."
  }
}

variable "databricks_workspace_url" {
  description = "The databricks workspace url"
  type        = string
  nullable    = false
}

variable "tags" {
  description = "A mapping of tags which should be assigned to all resources"
  type = object({
    resource-owner   = string
    contact-info     = string
    business-segment = string
    customer         = string
  })
}

variable "env" {
  description = "The Env"
  type        = string
  nullable    = false
}
