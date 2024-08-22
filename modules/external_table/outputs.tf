output "external_tables" {
  description = "external tables as a map"
  value       = tomap({ for k, t in databricks_sql_table.external_table : k => t.id })
}
