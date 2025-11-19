output "uami_ids" {
  description = "Map of UAMI names to their IDs"
  value = {
    for k, v in azurerm_user_assigned_identity.uami : k => v.id
  }
}

output "uami_principal_ids" {
  description = "Map of UAMI names to their principal IDs"
  value = {
    for k, v in azurerm_user_assigned_identity.uami : k => v.principal_id
  }
}

output "uami_client_ids" {
  description = "Map of UAMI names to their client IDs"
  value = {
    for k, v in azurerm_user_assigned_identity.uami : k => v.client_id
  }
}

output "uami_details" {
  description = "Detailed information about all UAMIs"
  value = {
    for k, v in azurerm_user_assigned_identity.uami : k => {
      id           = v.id
      name         = v.name
      principal_id = v.principal_id
      client_id    = v.client_id
      tenant_id    = v.tenant_id
    }
  }
}
