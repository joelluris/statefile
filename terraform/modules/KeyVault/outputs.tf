output "key_vault_ids" {
  value = { for k, kv in azurerm_key_vault.kv : k => kv.id }
}

output "key_id" {
  value = azurerm_key_vault_key.kv_key.id
}

output "disk_encryption_set_id" {
  value = azurerm_disk_encryption_set.kv_des.id
}

output "key_vault_details" {
  description = "Complete details of all ACRs"
  value = {
    for k, v in azurerm_key_vault.kv : k => {
      id           = v.id
      name         = v.name
      location     = v.location
      resource_group_name = v.resource_group_name}
  }
}
