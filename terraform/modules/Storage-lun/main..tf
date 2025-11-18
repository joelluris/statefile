resource "azurerm_storage_account" "storage" {
  for_each = var.storage_accounts

  name                      = each.value.storage_account_name
  resource_group_name       = each.value.resource_group_name
  location                  = each.value.location
  account_tier              = each.value.account_tier
  account_replication_type  = each.value.account_replication_type
  public_network_access_enabled = false
  allow_nested_items_to_be_public = false
  https_traffic_only_enabled = each.value.https_traffic_only_enabled
  tags                      = each.value.tags
}

# Private Endpoint for Storage Account Blob
resource "azurerm_private_endpoint" "storage_pe" {
  for_each            = var.storage_accounts
  name                = "${each.value.storage_account_name}-pe"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  subnet_id = var.snet_details_output["vnet-${var.environment}-uaen-01-snet-${var.environment}-pep-uaen-01"].id

  private_service_connection {
    name                           = "${each.value.storage_account_name}-blob-connection"
    private_connection_resource_id = azurerm_storage_account.storage[each.key].id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  tags = each.value.tags
}

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
