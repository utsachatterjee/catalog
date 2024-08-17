variable "shares" {
  type = map(object({
    comment = string
    owner = string
    recipient = list(string)
    objects = optional(list(object({
      catalog = string
      object_names = list(string)
      object_type = string
    })))
  }))
}

variable "databricks_workspace_url" {
  type = string
  nullable = false
}

variable "env" {
  type = string
  nullable = false
}