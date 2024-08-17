variable "external_volumes" {
  type = list(object({
    name         = string
    catalog_name = string
    schema_name  = string
    ext_location = string
    path         = string
    comment      = optional(string)
  }))
  description = "the schema definition object"
  nullable    = true
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
