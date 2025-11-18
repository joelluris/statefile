resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  address_space = var.address_space
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name

  address_prefixes = each.value.address_prefixes

  dynamic "delegation" {
    for_each = each.value.delegation != null ? each.value.delegation : []

    content {
      name = delegation.value.name
      dynamic "service_delegation" {
        for_each = delegation.value.service_delegation != null ? delegation.value.service_delegation : []

        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.actions
        }
      }
    }
  }
}

resource "azurerm_network_security_group" "nsg" {
  for_each = var.network_security_group

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "security_rule" {
    for_each = each.value.rules

    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = security_rule.value.source_port_range
      source_port_ranges           = security_rule.value.source_port_ranges
      destination_port_range       = security_rule.value.destination_port_range
      destination_port_ranges      = security_rule.value.destination_port_ranges
      source_address_prefix        = security_rule.value.source_address_prefix
      destination_address_prefixes = security_rule.value.destination_address_prefixes
      destination_address_prefix   = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for k, v in var.subnets : k => v
    if v.nsg_key != null
  }

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.nsg_key].id
}

# Route Table (User Defined Routes)
# User sets in tfvars	lookup returns !NOT inverts to	Result
# disable_bgp_route_propagation = true	returns=true	!true = false	BGP disabled ✓
# disable_bgp_route_propagation = false	returns=false	!false = true	BGP enabled ✓
# (not set)	false (default)	!false = true	BGP enabled ✓
resource "azurerm_route_table" "route_table" {
  for_each = var.route_tables != null ? var.route_tables : {}

  name                          = each.value.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = !lookup(each.value, "disable_bgp_route_propagation", false)

  dynamic "route" {
    for_each = each.value.routes

    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }

  tags = var.tags
}

# Associate Route Table with Subnets
resource "azurerm_subnet_route_table_association" "route_table_association" {
  for_each = {
    for k, v in var.subnets : k => v
    if v.route_table_key != null
  }

  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = azurerm_route_table.route_table[each.value.route_table_key].id
}
