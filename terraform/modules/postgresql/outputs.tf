output "postgresql_server_ids" {
  description = "Map of PostgreSQL Flexible Server IDs"
  value       = { for k, v in azurerm_postgresql_flexible_server.postgresql_server : k => v.id }
}

output "postgresql_server_fqdns" {
  description = "Map of PostgreSQL Flexible Server FQDNs"
  value       = { for k, v in azurerm_postgresql_flexible_server.postgresql_server : k => v.fqdn }
}

output "postgresql_database_ids" {
  description = "Map of PostgreSQL database IDs"
  value       = { for k, v in azurerm_postgresql_flexible_server_database.postgresql_databases : k => v.id }
}

output "postgresql_admin_passwords" {
  description = "Map of PostgreSQL admin passwords (sensitive)"
  value       = { for k, v in random_password.postgresql_admin_password : k => v.result }
  sensitive   = true
}