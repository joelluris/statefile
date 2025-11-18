variable "role_assignments" {
  type = list(object({
    name                 = string
    principal_id         = string
    role_definition_name = string
    scope                = string
  }))
  description = "List of role assignments to create"
}
