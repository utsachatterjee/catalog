variable "receipients" {
  type = map(object({
    name = string
    comment = string
    authentication_type = string
    owner = string
    permission_required = bool
    grants = optional(list(object({
      principal  = string
      privileges = list(string)
    })))
  }))
}

variable "databricks_workspace_url" {
  type = string
  default = ""
}