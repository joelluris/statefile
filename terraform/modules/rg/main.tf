# resource "azurerm_resource_group" "main" {
#   for_each = toset(var.workloads)

#   name     = format("rg-%s-%s-%s-%02d", var.project_code, each.value, var.environment, var.resource_name_sequence_start)
#   location = var.location
#   tags     = var.tags
# }
