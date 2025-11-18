resource "azurerm_log_analytics_workspace" "law" {
  for_each            = var.loganalytics
  name                = each.value.name
   location            = var.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku
  tags                = each.value.tags
  depends_on = [var.resource_group_output]
}
