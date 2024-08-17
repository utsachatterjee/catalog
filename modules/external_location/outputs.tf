output "external_location" {
  description = "the external location path"
  value       = tomap({ for k, c in databricks_external_location.ext_locations : k => c.url })
}