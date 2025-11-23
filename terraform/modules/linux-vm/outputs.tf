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

output "vm_public_ips" {
  description = "Map of VM public IP addresses (if enabled)"
  value       = { for k, v in azurerm_public_ip.vm_pip : k => v.ip_address }
}

output "vm_principal_ids" {
  description = "Map of VM system-assigned managed identity principal IDs"
  value       = { for k, v in azurerm_linux_virtual_machine.vm : k => v.identity[0].principal_id }
}

output "ssh_key_vault_secret_ids" {
  description = "Map of Key Vault secret IDs containing SSH private keys"
  value       = { for k, v in azurerm_key_vault_secret.vm_ssh_private_key : k => v.id }
}
