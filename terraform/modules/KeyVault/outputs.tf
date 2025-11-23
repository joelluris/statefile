output "key_vault_ids" {
  value = { for k, kv in azurerm_key_vault.kv : k => kv.id }
}

output "key_id" {
  value = azurerm_key_vault_key.kv_key.id
}

output "disk_encryption_set_id" {
  value = azurerm_disk_encryption_set.kv_des.id
}
