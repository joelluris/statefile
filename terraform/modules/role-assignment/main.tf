resource "azurerm_role_assignment" "role_assignment" {
  for_each = { for assignment in var.role_assignments : assignment.name => assignment }

  principal_id         = each.value.principal_id
  role_definition_name = each.value.role_definition_name
  scope                = each.value.scope
}
