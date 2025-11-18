resource "azurerm_key_vault" "vm_kv" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.tenant.tenant_id

  sku_name                    = "standard"
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
  rbac_authorization_enabled  = true

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules = [
      "72.14.201.3/32",    # Joel - Abu Dhabi
    ]
  }
}

  # resource "azurerm_monitor_diagnostic_setting" "this" {
  #   name               = azurerm_key_vault.this.name
  #   target_resource_id = azurerm_key_vault.this.id

  #   log_analytics_workspace_id = var.log_analytics_workspace_id

  #    dynamic "enabled_log" {
  #      for_each = toset(data.azurerm_monitor_diagnostic_categories.this.logs)
  #      content {
  #        category = log.key
  #      }
  #    }

  #   dynamic "metric" {
  #     for_each = toset(data.azurerm_monitor_diagnostic_categories.this.metrics)
  #     content {
  #       category = metric.key
  #     }
  #   }
  # }

resource "azurerm_private_endpoint" "kv_pe" {
  name                = "pep-kv-lnt-eip-nonprod-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_ids[0]  # Fixed: use first subnet from list

  private_service_connection {
    name                           = "vaultcore"
    private_connection_resource_id = azurerm_key_vault.vm_kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "vaultcore"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}

resource "azurerm_key_vault_key" "kv_key" {
  name         = var.key_vault_key_name
  key_vault_id = azurerm_key_vault.vm_kv.id

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

  #   depends_on = [
  #     azurerm_role_assignment.terraform,
  #   ]
}

resource "azurerm_disk_encryption_set" "kv_des" {
  name                = var.disk_encryption_set_name
  location            = var.location
  resource_group_name = var.resource_group_name  # Fixed: use variable instead of data source
  key_vault_key_id    = azurerm_key_vault_key.kv_key.id  # Fixed: correct resource reference

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "this" {
  principal_id         = azurerm_disk_encryption_set.kv_des.identity[0].principal_id
  scope                = azurerm_key_vault.vm_kv.id  # Fixed: correct resource reference
  role_definition_name = "Key Vault Crypto Service Encryption User"
}

# resource "azurerm_key_vault_secret" "this" {
#   for_each = {
#     for secret in var.secrets : secret.name => secret
#   }

#   name         = each.key
#   key_vault_id = azurerm_key_vault.vm_kv.id
#   value        = each.value.value
# }
