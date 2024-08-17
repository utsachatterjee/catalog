output "schemas" {
  description = "schemas as a map"
  value       = tomap({ for k, s in databricks_schema.schema : k => element(split(".", s.id), 1) })
}
