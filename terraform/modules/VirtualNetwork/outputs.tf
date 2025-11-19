output "vnet_details_output" {
  description = "The names and IDs of all virtual networks."
  value = {
    for k, v in azurerm_virtual_network.vnets : k => {
      name = v.name
      id   = v.id
    }
  }
}

output "snet_details_output" {
  value = {
    for subnet in azurerm_subnet.subnets : "${subnet.virtual_network_name}-${subnet.name}" => {
      name = subnet.name
      id   = subnet.id
    }
  }
}

output "subnet_ids" {
  description = "A map of subnet names to their IDs."
  value       = { for k, s in azurerm_subnet.subnets : k => s.id }
}

output "vnet_ids" {
  description = "A map of virtual network names to their IDs."
  value       = { for k, v in azurerm_virtual_network.vnets : k => v.id }
}
