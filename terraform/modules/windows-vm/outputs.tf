# ==========================================================================================
# Windows VM Module Outputs
# ==========================================================================================

output "vm_ids" {
  description = "Map of VM names to their IDs"
  value       = { for k, v in azurerm_windows_virtual_machine.vm : k => v.id }
}

output "vm_names" {
  description = "Map of VM keys to their names"
  value       = { for k, v in azurerm_windows_virtual_machine.vm : k => v.name }
}

output "vm_private_ips" {
  description = "Map of VM keys to their private IP addresses"
  value       = { for k, v in azurerm_network_interface.vm_nic : k => v.private_ip_address }
}

output "vm_identity_principal_ids" {
  description = "Map of VM keys to their system assigned identity principal IDs"
  value       = { for k, v in azurerm_windows_virtual_machine.vm : k => v.identity[0].principal_id }
}

output "vm_public_ips" {
  description = "Map of VM keys to their public IP addresses (only for VMs with public IP enabled)"
  value       = { for k, v in azurerm_public_ip.vm_pip : k => v.ip_address }
}
