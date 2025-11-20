# ==========================================================================================
# VNet Peering Module - Hub and Spoke Topology
# - Creates peering from spoke VNet to hub VNet (in spoke subscription)
# - Creates peering from hub VNet to spoke VNet (in hub/connectivity subscription)
# ==========================================================================================

# Peering from spoke to hub (created in spoke subscription)
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  for_each                  = var.vnets
  name                      = "peer-${each.value.name}-to-hub"
  resource_group_name       = each.value.rg_name
  virtual_network_name      = each.value.name
  remote_virtual_network_id = var.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = var.use_remote_gateways
}

# Peering from hub to spoke (created in hub/connectivity subscription)
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  for_each                  = var.vnets
  provider                  = azurerm.connectivity
  name                      = "peer-hub-to-${each.value.name}"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = each.value.vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = var.hub_allow_gateway_transit
  use_remote_gateways          = false
}
