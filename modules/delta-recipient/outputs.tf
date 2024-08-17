output "receipients" {
  description = "receipients as a map"
  value       = tomap({ for k, c in databricks_recipient.db2db : k => c.name })
}