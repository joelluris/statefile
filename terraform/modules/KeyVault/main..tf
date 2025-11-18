resource "azurerm_key_vault" "kv" {
  for_each            = var.key_vault
  name                = each.value.kv_name
   tenant_id           = var.tenant_id
   location            = var.location
  resource_group_name = var.key_vault[each.key].kv_rg_name
  sku_name            = each.value.sku
  tags                = each.value.tags
  depends_on = [var.resource_group_output]

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules = local.combined_ip_ranges
  }
}

locals {
  combined_ip_ranges = flatten([
    var.Arcon_PAM_IP,
    var.umbrella_ip_range,
    var.AzureDevopsrunner
  ])
}
