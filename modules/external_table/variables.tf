variable "external_tables" {
  type = map(object({
    name               = string
    catalog_name       = string
    schema_name        = string
    data_source_format = string
    storage_location   = string
    columns = list(object({
      name = string
      type = string
    }))
    partitions = optional(list(string))
    options    = optional(map(string))
    properties = optional(map(string))
    comment    = optional(string)
  }))
  description = "the external table definition object"
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

variable "databricks_storage_credential_id" {
  description = "The databricks storage credential id"
  type        = string
  nullable    = false
}
