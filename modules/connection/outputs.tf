output "connections" {
  description = "connections as a map"
  value       = tomap({ for k, c in databricks_connection.connection : k => c.name })
}
