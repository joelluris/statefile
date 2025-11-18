# output "vnet_name" {
# 	description = "The name of the virtual network."
# 	value       = azurerm_virtual_network.vnet.name
# }

# output "vnet_id" {
# 	description = "The ID of the virtual network."
# 	value       = azurerm_virtual_network.vnet.id
# }

# output "subnet_ids" {
# 	description = "A map of subnet names to their IDs."
# 	value       = { for k, s in azurerm_subnet.subnets : k => s.id }
# }

# output "nsg_ids" {
#   description = "A map of network security group names to their IDs."
#   value       = { for k, nsg in azurerm_network_security_group.nsg : k => nsg.id }
# }