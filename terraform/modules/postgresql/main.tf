resource "random_password" "postgresql_admin_password" {
  for_each = var.postgresql_servers

  length      = 24
  min_lower   = 3
  min_upper   = 3
  min_numeric = 3
  min_special = 3
}

resource "azurerm_key_vault_secret" "psql_password" {
  for_each = var.postgresql_servers

  name            = "${each.key}-psql-admin-password"
  value           = random_password.postgresql_admin_password[each.key].result
  key_vault_id    = var.key_vault_id
  expiration_date = timeadd(timestamp(), "2160h") # 90 days expiration (common policy limit)

  lifecycle {
    ignore_changes = [expiration_date]
  }

  depends_on = [random_password.postgresql_admin_password]
}

resource "azurerm_postgresql_flexible_server" "postgresql_server" {
  for_each = var.postgresql_servers

  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  sku_name                      = each.value.sku_name
  version                       = each.value.version
  storage_mb                    = each.value.storage_mb
  backup_retention_days         = each.value.backup_retention_days
  geo_redundant_backup_enabled  = each.value.geo_redundant_backup
  administrator_login           = each.value.administrator_login
  administrator_password        = random_password.postgresql_admin_password[each.key].result
  delegated_subnet_id           = each.value.delegated_subnet_id != null ? (can(regex("^/subscriptions/", each.value.delegated_subnet_id)) ? each.value.delegated_subnet_id : var.subnet_ids[each.value.delegated_subnet_id]) : null
  private_dns_zone_id           = each.value.private_dns_zone_id != null ? each.value.private_dns_zone_id : var.postgresql_dns_zone_id
  public_network_access_enabled = each.value.delegated_subnet_id != null ? false : true
  zone                          = "1"

  dynamic "high_availability" {
    for_each = each.value.high_availability != null ? [each.value.high_availability] : []
    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = high_availability.value.standby_availability_zone
    }
  }

  tags = each.value.tags

  depends_on = [random_password.postgresql_admin_password]
}

resource "azurerm_postgresql_flexible_server_database" "postgresql_databases" {
  for_each = var.postgresql_databases

  name      = each.value.name
  server_id = azurerm_postgresql_flexible_server.postgresql_server[each.value.server_key].id
  charset   = each.value.charset
  collation = each.value.collation

  depends_on = [azurerm_postgresql_flexible_server.postgresql_server]
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "postgresql_firewall_rules" {
  for_each = var.postgresql_firewall_rules

  name             = each.value.name
  server_id        = azurerm_postgresql_flexible_server.postgresql_server[each.value.server_key].id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address

  depends_on = [azurerm_postgresql_flexible_server.postgresql_server]
}
