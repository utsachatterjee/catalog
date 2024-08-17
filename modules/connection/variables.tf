variable "connections" {
  type = list(object({
    name            = string
    connection_type = string
    env_vars = map(object({
      options    = map(any)
      properties = map(any)
      comment    = optional(string)
      grants = list(object({
        principal  = string
        privileges = list(string)
      }))
    }))
  }))
  description = "the connection definition object"
  nullable    = false

  validation {
    condition     = !contains(flatten([for k, v in var.connections : [for k, e in v.env_vars : [for i, s in e.grants : strcontains(s.principal, "@")]]]), true)
    error_message = "The principal value in the 'grants' section must be a group. It can't be an user email."
  }

  validation {
    condition     = !contains(flatten([for k, v in var.connections : [for k, e in v.env_vars : [for i, s in e.grants : contains(s.privileges, "ALL_PRIVILEGES")]]]), true)
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
