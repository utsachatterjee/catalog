variable "materialized_views" {
  type = map(object({
    name            = string
    catalog_name    = string
    schema_name     = string
    view_definition = string
    properties      = optional(map(string))
    comment         = optional(string)
  }))
  description = "the materialized view definition object"
  nullable    = true
}

variable "databricks_workspace_url" {
  description = "The databricks workspace url"
  type        = string
  nullable    = false
}

variable "env" {
  description = "The Env"
  type        = string
  nullable    = false
}
