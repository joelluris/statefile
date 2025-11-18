# Linux VM Module Outputs

output "vm_ids" {
  description = "Map of VM IDs"
  value       = { for k, v in azurerm_linux_virtual_machine.vm : k => v.id }
}

output "vm_names" {
  description = "Map of VM names"
  value       = { for k, v in azurerm_linux_virtual_machine.vm : k => v.name }
}

output "vm_private_ips" {
  description = "Map of VM private IP addresses"
  value       = { for k, v in azurerm_network_interface.vm_nic : k => v.private_ip_address }
}

output "vm_identity_principal_ids" {
  description = "Map of VM system assigned identity principal IDs"
  value       = { for k, v in azurerm_linux_virtual_machine.vm : k => v.identity[0].principal_id }
}

output "data_disk_ids" {
  description = "Map of data disk IDs"
  value       = { for k, v in azurerm_managed_disk.data_disk : k => v.id }
}
