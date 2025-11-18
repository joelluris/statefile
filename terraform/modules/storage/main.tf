resource "azurerm_storage_account" "this" {
  name                = format("st%s%s%s%03d", var.project, var.environment, var.location, var.suffix)
  location            = var.location
  resource_group_name = data.azapi_resource_id.resource_group.name

  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name               = azurerm_storage_account.this.name
  target_resource_id = azurerm_storage_account.this.id

  log_analytics_workspace_id = var.log_analytics_workspace_id

  #  dynamic "enabled_log" {
  #    for_each = toset(data.azurerm_monitor_diagnostic_categories.this.logs)
  #    content {
  #      category = log.key
  #    }
  #  }

  dynamic "metric" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.this.metrics)
    content {
      category = metric.key
    }
  }
}

resource "azurerm_private_endpoint" "this" {
  name                = format("pep-st%s%s%s%03d", var.project, var.environment, var.location, var.suffix)
  location            = var.location
  resource_group_name = data.azapi_resource_id.resource_group.name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "blob"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "blob"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}

resource "azurerm_monitor_diagnostic_setting" "private_endpoint" {
  name               = azurerm_private_endpoint.this.name
  target_resource_id = azurerm_private_endpoint.this.network_interface[0].id

  log_analytics_workspace_id = var.log_analytics_workspace_id

  #  dynamic "enabled_log" {
  #    for_each = toset(data.azurerm_monitor_diagnostic_categories.private_endpoint.logs)
  #    content {
  #      category = log.key
  #    }
  #  }

  dynamic "metric" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.private_endpoint.metrics)
    content {
      category = metric.key
    }
  }
}

resource "azurerm_storage_container" "this" {
  for_each = {
    for container in var.containers : container.name => container
  }

  name                 = each.value.name
  storage_account_name = azurerm_storage_account.this.name
}

resource "azurerm_role_assignment" "contributors" {
  for_each = {
    for contributor in flatten([
      for container in var.containers : [
        for contributor_key, contributor in container.contributors : {
          key       = format("%s-%s", contributor_key, container.name)
          principal = contributor
          scope     = container.name
        }
      ]
    ]) : contributor.key => contributor
  }

  principal_id         = data.azurerm_user_assigned_identity.contributors[each.value.key].principal_id
  scope                = azurerm_storage_container.this[each.value.scope].resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
}
