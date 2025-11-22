resource "azurerm_key_vault" "kv" {
  for_each                        = var.key_vault
  name                            = each.value.kv_name
  tenant_id                       = var.tenant_id
  location                        = var.location
  resource_group_name             = var.key_vault[each.key].kv_rg_name
  sku_name                        = each.value.sku
  purge_protection_enabled        = each.value.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_enabled ? each.value.soft_delete_retention_days : 7  # Minimum recommended: 90 days
  
  # enabled_for_disk_encryption     = true
  # enabled_for_deployment          = false
  # enabled_for_template_deployment = false
  public_network_access_enabled   = each.value.public_network_access_enabled  # Disable public access, use private endpoint only
  tags                            = each.value.tags
  depends_on                      = [var.resource_group_output]

  network_acls {
    default_action = "Allow"
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

resource "azurerm_disk_encryption_set" "kv_des" {
  name                = var.disk_encryption_set_name
  location            = var.location
  # [0] gets the first key from the key_vault map (e.g., "kv01")
  resource_group_name = var.key_vault[keys(var.key_vault)[0]].kv_rg_name
  key_vault_key_id    = azurerm_key_vault_key.kv_key.id

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_key_vault_key.kv_key]
}

# Grant the Disk Encryption Set access to the Key Vault Key
resource "azurerm_key_vault_access_policy" "des_policy" {
  # [0] gets the first key vault from the map (since we use for_each on key_vault)
  key_vault_id = azurerm_key_vault.kv[keys(var.key_vault)[0]].id
  tenant_id    = var.tenant_id
  # [0] gets the first (and only) identity from the identity block list
  object_id    = azurerm_disk_encryption_set.kv_des.identity[0].principal_id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]

  depends_on = [azurerm_disk_encryption_set.kv_des]
}

resource "azurerm_key_vault_key" "kv_key" {
  name         = var.key_vault_key_name
  # [0] gets the first key vault from the map to store the encryption key
  key_vault_id = azurerm_key_vault.kv[keys(var.key_vault)[0]].id

  key_type = "RSA"
  key_size = 4096
  key_opts = [
    "encrypt",
    "decrypt",
    "sign",
    "verify",
    "wrapKey",
    "unwrapKey",
  ]

  depends_on = [azurerm_key_vault.kv]
}

resource "azurerm_role_assignment" "this" {
  # [0] gets the first (and only) system-assigned identity's principal_id
  principal_id         = azurerm_disk_encryption_set.kv_des.identity[0].principal_id
  # [0] gets the first key vault from the map
  scope                = azurerm_key_vault.kv[keys(var.key_vault)[0]].id
  role_definition_name = "Key Vault Crypto Service Encryption User"
}
