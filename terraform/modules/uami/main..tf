# Create User Assigned Managed Identities
resource "azurerm_user_assigned_identity" "uami" {
  for_each            = var.user_assigned_managed_identities
  name                = each.value.name
  resource_group_name = each.value.rg_name
  location            = each.value.location
}

# Flatten role assignments for easier iteration
locals {
  role_assignments = flatten([
    for uami_key, uami in var.user_assigned_managed_identities : [
      for ra_key, ra in uami.role_assignments : {
        uami_key             = uami_key
        ra_key               = ra_key
        uami_name            = uami.name
        role_definition_name = ra.role_definition_name
        scope_type           = ra.scope_type
        scope_name           = ra.scope
        principal_id         = azurerm_user_assigned_identity.uami[uami_key].principal_id
      }
    ]
  ])

  # Create a map of all UAMIs for cross-reference lookups
  uami_id_map = {
    for k, v in azurerm_user_assigned_identity.uami : v.name => v.id
  }
}

# Assign roles to UAMIs with dynamic scope resolution
resource "azurerm_role_assignment" "uami_roles" {
  for_each = {
    for ra in local.role_assignments : "${ra.uami_key}-${ra.ra_key}" => ra
  }

  principal_id         = each.value.principal_id
  role_definition_name = each.value.role_definition_name
  
  # Dynamic scope resolution based on scope_type
  scope = (
    each.value.scope_type == "resource_group" ? var.rg_ids[each.value.scope_name] :
    each.value.scope_type == "key_vault" ? var.key_vault_ids[each.value.scope_name] :
    # each.value.scope_type == "storage_account" ? var.storage_account_ids[each.value.scope_name] :
    # each.value.scope_type == "azure_container_registry" ? var.acr_ids[each.value.scope_name] :
    each.value.scope_type == "user_assigned_managed_identity" ? local.uami_id_map[each.value.scope_name] :
    each.value.scope_name # Fallback to the scope name as-is if it's already an ID
  )

  depends_on = [azurerm_user_assigned_identity.uami]
}
