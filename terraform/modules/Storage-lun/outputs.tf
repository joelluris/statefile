# Output for Private Endpoint IPs
output "private_endpoint_ips" {
  value = { for k, v in azurerm_private_endpoint.storage_pe : k => v.private_service_connection[0].private_ip_address }
}

output "storage_account_names" {
  value = { for k, v in azurerm_storage_account.storage : k => v.name }
}

output "storage_account_ids" {
  value = { for k, v in azurerm_storage_account.storage : k => v.id }
}

output "primary_blob_endpoints" {
  value = { for k, v in azurerm_storage_account.storage : k => v.primary_blob_endpoint }
}
