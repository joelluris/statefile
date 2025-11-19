output "key_vault_ids" {
  value = { for kv in azurerm_key_vault.kv : kv.name => kv.id }
}