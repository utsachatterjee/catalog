variable "catalogs" {
  type = list(object({
    name          = string
    comment       = optional(string)
    force_destroy = bool
    grants = list(object({
      principal  = string
      privileges = list(string)
    }))
  }))
  description = "the catalog definition object"
  nullable    = false

  validation {
    condition     = !contains(flatten([for k, v in var.catalogs : [for i, s in v.grants : strcontains(s.principal, "@")]]), true)
    error_message = "The principal value in the 'grants' section must be a group. It can't be an user email."
  }

  validation {
    condition     = !contains(flatten([for k, v in var.catalogs : [for i, s in v.grants : contains(s.privileges, "ALL_PRIVILEGES")]]), true)
    error_message = "'ALL_PRIVILEGES' is not allowd in the privileges."
  }

  validation {
    condition     = !contains(flatten([for k, v in var.catalogs : [for i, s in v.grants : contains(s.privileges, "CREATE_VOLUME")]]), true)
    error_message = "'CREATE_VOLUME' is not allowd in the privileges."
  }

  validation {
    condition     = !contains(flatten([for k, v in var.catalogs : [for i, s in v.grants : contains(s.privileges, "CREATE_SCHEMA")]]), true)
    error_message = "'CREATE_SCHEMA' is not allowd in the privileges."
  }
}

variable "metastore_id" {
  description = "metastore id"
  type        = string
  nullable    = false
}

variable "storage_root" {
  description = "storage root"
  type        = string
  nullable    = false
}

variable "backup_storage_root" {
  description = "backup storage root"
  type        = string
  nullable    = false
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
