# output "identities" {
#   description = "Map of all user assigned managed identities"
#   value       = azurerm_user_assigned_identity.uami
# }

# output "resource_ids" {
#   description = "Map of resource IDs for each UAMI"
#   value       = { for k, v in azurerm_user_assigned_identity.uami : k => v.id }
# }

# output "principal_ids" {
#   description = "Map of principal IDs for each UAMI"
#   value       = { for k, v in azurerm_user_assigned_identity.uami : k => v.principal_id }
# }

# output "client_ids" {
#   description = "Map of client IDs for each UAMI"
#   value       = { for k, v in azurerm_user_assigned_identity.uami : k => v.client_id }
# }
