resource "azurerm_storage_account" "storage" {
  for_each = var.storage_accounts

  name                              = each.value.storage_account_name
  resource_group_name               = each.value.resource_group_name
  location                          = each.value.location
  account_tier                      = each.value.account_tier
  account_replication_type          = each.value.account_replication_type
  public_network_access_enabled     = false
  allow_nested_items_to_be_public   = false
  https_traffic_only_enabled        = true  # Always enforce HTTPS
  min_tls_version                   = "TLS1_2"  # Minimum TLS version
  shared_access_key_enabled         = true
  infrastructure_encryption_enabled = true  # Enable double encryption
  tags                              = each.value.tags

  blob_properties {
    versioning_enabled       = true
    change_feed_enabled      = true
    last_access_time_enabled = true

    delete_retention_policy {
      days = 7
    }

    container_delete_retention_policy {
      days = 7
    }
  }
}

# Private Endpoint for Storage Account Blob
resource "azurerm_private_endpoint" "storage_pe" {
  for_each            = var.storage_accounts
  name                = "pe-${each.value.storage_account_name}"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${each.value.storage_account_name}-blob"
    private_connection_resource_id = azurerm_storage_account.storage[each.key].id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-group-${each.value.storage_account_name}"
    private_dns_zone_ids = [var.blob_dns_zone_id]
  }

  tags = each.value.tags
}

