data "azapi_resource_id" "resource_group" {
  type        = "Microsoft.Resources/resourceGroups@latest"
  resource_id = var.resource_group_id
}

data "azurerm_monitor_diagnostic_categories" "this" {
  resource_id = azurerm_storage_account.this.id
}

data "azurerm_monitor_diagnostic_categories" "private_endpoint" {
  resource_id = azurerm_private_endpoint.this.network_interface[0].id
}

data "azapi_resource_id" "user_assigned_identity" {
  for_each = {
    for contributor in flatten([
      for container in var.containers : [
        for contributor_key, contributor in container.contributors : {
          key         = format("%s-%s", contributor_key, container.name)
          resource_id = contributor
        }
      ]
    ]) : contributor.key => contributor
  }

  type        = "Microsoft.ManagedIdentity/userAssignedIdentities@latest"
  resource_id = each.value.resource_id
}

data "azurerm_user_assigned_identity" "contributors" {
  for_each = {
    for contributor in flatten([
      for container in var.containers : [
        for contributor_key, contributor in container.contributors : {
          key = format("%s-%s", contributor_key, container.name)
        }
      ]
    ]) : contributor.key => contributor
  }

  resource_group_name = data.azapi_resource_id.user_assigned_identity[each.key].resource_group_name
  name                = data.azapi_resource_id.user_assigned_identity[each.key].name
}
