# PostgreSQL Private DNS Zone
output "postgresql_private_dns_zone_id" {
  description = "PostgreSQL Private DNS Zone ID"
  value       = data.azurerm_private_dns_zone.dns_zones["psql"].id
}

output "snet_details_output" {
  value = module.VirtualNetwork.snet_details_output
}

output "vnet_details_output" {
  value = module.VirtualNetwork.vnet_details_output
}