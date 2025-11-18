resource "azurerm_virtual_network" "vnets" {
  for_each            = can(var.vnets) ? var.vnets : {}
  name                = each.value.name
  resource_group_name = var.rg_details_input[each.value.rg_name]
  location            = var.location
  address_space       = each.value.cidr
  dns_servers         = each.value.dns
  tags                = each.value.tags
}

locals {
  network_subnets = flatten([
    for network_key, network in var.vnets : [
      for subnet_key, subnet in network.subnets : {
        network_key          = network_key
        subnet_key           = subnet_key
        address_prefixes     = subnet.cidr
        subnet_name          = subnet.name
        virtual_network_name = azurerm_virtual_network.vnets[network_key].name
        resource_group_name  = azurerm_virtual_network.vnets[network_key].resource_group_name
        service_delegation   = subnet.service_delegation
      }
    ]
  ])
}

locals {
  flattened_nsg_snet_rules = flatten([
    for nsg_snet_key, nsg_snet in var.nsg_snet : [
      for rule_key, rule in nsg_snet.rules : {
        nsg_snet_key                 = nsg_snet_key
        rule_key                     = rule_key
        nsg_snet_name                = nsg_snet.name
        resource_group               = nsg_snet.rg_name
        rule_name                    = rule.name
        priority                     = rule.priority
        direction                    = rule.direction
        access                       = rule.access
        protocol                     = rule.protocol
        source_port_range            = rule.source_port_range
        destination_port_range       = rule.destination_port_range
        destination_port_ranges      = rule.destination_port_ranges
        source_address_prefix        = rule.source_address_prefix
        destination_address_prefix   = rule.destination_address_prefix
        destination_address_prefixes = rule.destination_address_prefixes
      }
    ]
  ])
}

resource "azurerm_network_security_group" "nsg_snet" {
  for_each            = var.nsg_snet
  name                = each.value.name
  location            = var.location
  resource_group_name = var.rg_details_input[each.value.rg_name]
}

resource "azurerm_network_security_rule" "nsg_snet_rules" {
  for_each = {
    for rule in local.flattened_nsg_snet_rules : "${rule.nsg_snet_key}-${rule.rule_key}" => rule
  }
  name                        = each.value.rule_name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  source_address_prefix       = each.value.source_address_prefix
  resource_group_name         = each.value.resource_group
  network_security_group_name = azurerm_network_security_group.nsg_snet[each.value.nsg_snet_key].name
  # Conditional assignment for destination ports
  destination_port_range  = length(each.value.destination_port_ranges) == 0 ? each.value.destination_port_range : null
  destination_port_ranges = length(each.value.destination_port_ranges) > 0 ? each.value.destination_port_ranges : null
  # Conditional assignment for destination address prefix
  destination_address_prefix   = length(each.value.destination_address_prefixes) == 0 ? each.value.destination_address_prefix : null
  destination_address_prefixes = length(each.value.destination_address_prefixes) > 0 ? each.value.destination_address_prefixes : null
}

# Subnet association with nsg_snet
resource "azurerm_subnet_network_security_group_association" "nsg_snet_subnet_associations" {
  for_each                  = { for nsg_snet_key, nsg_snet in var.nsg_snet : "${nsg_snet.vnet_name}-${nsg_snet.snet_name}" => nsg_snet_key }
  subnet_id                 = local.subnet_id_mapping[each.key]
  network_security_group_id = azurerm_network_security_group.nsg_snet[each.value].id
  depends_on                = [azurerm_subnet.subnets, azurerm_network_security_rule.nsg_snet_rules]
}

resource "azurerm_subnet" "subnets" {
  for_each = {
    for sn in local.network_subnets : "${sn.network_key}.${sn.subnet_key}" => sn
  }
  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = tolist([each.value.address_prefixes])
  dynamic "delegation" {
    for_each = each.value.service_delegation != "" ? [each.value.service_delegation] : []
    content {
      name = "delegation"
      service_delegation {
        name = each.value.service_delegation
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
        ]
      }
    }
  }
  depends_on = [azurerm_virtual_network.vnets]
}

###############################
# Begin 2 ways VNET PEERING
###############################

locals {
  remote_vnet_ids = {
    for k, v in var.vnets :
    v.name => azurerm_virtual_network.vnets[k].id
  }
}

# Fetch Shared Vnet ID
data "terraform_remote_state" "tfstate_shared" {
  backend = "azurerm"  
  config = {
    resource_group_name  = var.tf_storage_resource_group
    storage_account_name = var.tf_storage_account_name
    container_name       = var.tf_container_name
    key                 = "shared.tfstate"
    access_key          = var.tf_storage_access_key
  }
}

locals {
  shared_vnet_ids = {
    for k, v in data.terraform_remote_state.tfstate_shared.outputs.vnet_details_output : v.name => v.id
  }
}
resource "azurerm_virtual_network_peering" "peer_remote" {
  for_each             = var.enable_vnet_peering_remote ? var.vnet_peering_remote : {}
  name                 = "peer-${each.value.source_vnet_name}-to-${each.value.remote_vnet_name}"
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.source_vnet_name
  remote_virtual_network_id = (
    each.value.remote_environment == "shared" ? local.shared_vnet_ids[each.value.remote_vnet_name] :
    null
  )
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways
  depends_on                   = [azurerm_virtual_network.vnets]
}
###############################
#   End VNET PEERING
###############################

# Route table creation
locals {
  subnet_id_mapping = {
    for subnet in azurerm_subnet.subnets : "${subnet.virtual_network_name}-${subnet.name}" => subnet.id
  }
}

output "subnet_id_mapping_debug" {
  value = local.subnet_id_mapping
}

locals {
  flattened_routes = flatten([
    for rt_key, rt in var.routetables : [
      for route_key, route in rt.routes : {
        rt_key           = rt_key
        route_key        = route_key
        route_table_name = rt.name
        resource_group   = rt.rg_name
        vnet_name        = rt.vnet_name
        subnet_name      = rt.snet_name
        route_name       = route.name
        address_prefixes = route.address_prefixes
        next_hop_type    = route.next_hop_type
        next_hop_ip      = route.next_hop_ip
      }
    ]
  ])
}

# Route table resource creation
 resource "azurerm_route_table" "route_tables" {
   for_each                      = var.routetables
   name                          = each.value.name
   resource_group_name           = each.value.rg_name
   location                      = var.location
   tags                          = each.value.tags
   bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
   depends_on                    = [azurerm_subnet.subnets]
 }

# Route resource creation inside the route table
 resource "azurerm_route" "routes" {
   for_each               = { for route in local.flattened_routes : "${route.rt_key}-${route.route_key}" => route }
   name                   = each.value.route_name
   resource_group_name    = each.value.resource_group
   route_table_name       = azurerm_route_table.route_tables[each.value.rt_key].name
   address_prefix         = each.value.address_prefixes[0]
   next_hop_type          = each.value.next_hop_type
   next_hop_in_ip_address = each.value.next_hop_ip
   depends_on             = [azurerm_route_table.route_tables]
 }

 # Subnet association with route table
 resource "azurerm_subnet_route_table_association" "subnet_associations" {
   for_each       = { for rt_key, rt in var.routetables : "${rt.vnet_name}-${rt.snet_name}" => rt_key }
   subnet_id      = local.subnet_id_mapping[each.key]
   route_table_id = azurerm_route_table.route_tables[each.value].id
   depends_on     = [azurerm_route.routes]
 }

