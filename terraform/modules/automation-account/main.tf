resource "azurerm_automation_account" "automation" {
  for_each = var.automation_accounts
    name                = each.value.name
    resource_group_name = each.value.resource_group_name
    location            = each.value.location
    sku_name            = each.value.sku_name
    tags                = each.value.tags

    identity {
        type = "SystemAssigned"
    }
}

# Runbooks
resource "azurerm_automation_runbook" "runbook" {
  for_each = var.runbooks

  name                    = each.value.name
  automation_account_name = azurerm_automation_account.automation[each.value.automation_account_key].name
  resource_group_name     = each.value.resource_group_name
  location                = each.value.location
  runbook_type            = each.value.runbook_type
  log_verbose             = each.value.log_verbose
  log_progress            = each.value.log_progress
  description             = each.value.description
  content                 = each.value.script_path != null ? file(each.value.script_path) : each.value.content

  depends_on = [azurerm_automation_account.automation]
}

# Schedules
resource "azurerm_automation_schedule" "schedule" {
  for_each = var.schedules

  name                    = each.value.name
  automation_account_name = azurerm_automation_account.automation[each.value.automation_account_key].name
  resource_group_name     = each.value.resource_group_name
  frequency               = each.value.frequency
  interval                = each.value.interval
  timezone                = each.value.timezone
  start_time              = each.value.start_time
  description             = each.value.description
  week_days               = each.value.week_days

  depends_on = [azurerm_automation_account.automation]
}

# Job Schedules (link runbooks to schedules)
resource "azurerm_automation_job_schedule" "job_schedule" {
  for_each = var.job_schedules

  automation_account_name = azurerm_automation_account.automation[each.value.automation_account_key].name
  resource_group_name     = each.value.resource_group_name
  runbook_name            = each.value.runbook_name
  schedule_name           = each.value.schedule_name
  parameters              = each.value.parameters

  depends_on = [
    azurerm_automation_runbook.runbook,
    azurerm_automation_schedule.schedule
  ]
}

# Role Assignments for Managed Identity
resource "azurerm_role_assignment" "automation_role" {
  for_each = var.role_assignments

  principal_id         = azurerm_automation_account.automation[each.value.automation_account_key].identity[0].principal_id
  role_definition_name = each.value.role_definition_name
  scope                = each.value.scope

  depends_on = [azurerm_automation_account.automation]
}