variable "databricks_external_location_name" {
  description = "The databricks external location name"
  type        = string
  nullable    = false
}

variable "databricks_external_location_storage_container_name" {
  description = "The databricks external location storage container name"
  type        = string
  nullable    = false
}

variable "databricks_external_location_storage_account_name" {
  description = "The databricks external location storage account name"
  type        = string
  nullable    = false
}

variable "databricks_external_location_backup_storage_account_name" {
  description = "The databricks external location backup storage account name"
  type        = string
  nullable    = false
}

variable "databricks_external_location_path" {
  description = "The databricks external location path"
  type        = string
  nullable    = false
}

variable "databricks_storage_credential_id" {
  description = "The databricks storage credential id"
  type        = string
  nullable    = false
}

variable "databricks_external_location_comment" {
  description = "The databricks external location comment"
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

variable "ext_locations" {
  description = "external locations required to mount storages as external volumes"
  type = map(object({
    name    = string
    url     = map(any)
    comment = string
    grants = list(object({
      principal  = string
      privileges = list(string)
    }))

  }))
  default = {}
}
