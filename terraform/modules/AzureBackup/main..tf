resource "azurerm_recovery_services_vault" "rsv" {
  for_each            = var.BackupVault
  name                = each.value.rsv_vault_name
  location            = each.value.location
  resource_group_name = each.value.rsv_resource_group_name
  sku                 = each.value.rsv_vault_sku
  soft_delete_enabled = each.value.soft_delete_enabled
  tags                = each.value.tags
  depends_on = [var.resource_group_output]
}
resource "azurerm_backup_policy_vm" "policy" {
  for_each = var.BackupPolicy

  name                           = each.value.backup_policy_name
  resource_group_name            = each.value.rsv_resource_group_name
  recovery_vault_name            = each.value.rsv_vault_name
  timezone                       = each.value.timezone
  instant_restore_retention_days = each.value.instant_restore_retention_days

  backup {
    frequency = each.value.backup_frequency
    time      = each.value.backup_time
  }

  retention_daily {
    count = each.value.retention_daily
  }

  retention_weekly {
    count    = each.value.retention_weekly
    weekdays = each.value.retention_weekly_days
  }

  retention_monthly {
    count    = each.value.retention_monthly
    weeks    = each.value.retention_monthly_week
    weekdays = each.value.retention_monthly_days
  }

  retention_yearly {
    count    = each.value.retention_yearly
    months   = each.value.retention_yearly_month
    weeks    = each.value.retention_yearly_week
    weekdays = each.value.retention_yearly_days
  }

  depends_on = [azurerm_recovery_services_vault.rsv]
}
