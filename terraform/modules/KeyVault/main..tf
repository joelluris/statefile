resource "azurerm_key_vault" "kv" {
  for_each            = var.key_vault
  name                = each.value.kv_name
  tenant_id           = var.tenant_id
  location            = var.location
  resource_group_name = var.key_vault[each.key].kv_rg_name
  sku_name            = each.value.sku
  tags                = each.value.tags
  depends_on          = [var.resource_group_output]

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = local.combined_ip_ranges
  }
}

locals {
  combined_ip_ranges = flatten([
    var.Arcon_PAM_IP,
    var.umbrella_ip_range,
    var.AzureDevopsrunner
  ])
}

# Private Endpoint for Key Vault
resource "azurerm_private_endpoint" "kv_pe" {
  for_each            = var.key_vault
  name                = "pe-${each.value.kv_name}"
  location            = var.location
  resource_group_name = each.value.kv_rg_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${each.value.kv_name}"
    private_connection_resource_id = azurerm_key_vault.kv[each.key].id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "pdz-group-${each.value.kv_name}"
    private_dns_zone_ids = [var.private_dns_zone_ids["vaultcore"]]
  }

  depends_on = [azurerm_key_vault.kv]
}
