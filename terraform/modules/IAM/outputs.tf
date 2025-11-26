output "azure_network_admins_id" {
  value = azuread_group.azure_network_admins.id
}

output "azure_security_admins_id" {
  value = azuread_group.azure_security_admins.id
}

output "azure_vm_contributors_id" {
  value = azuread_group.azure_vm_contributors.id
}
