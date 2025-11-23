variable "acr" {
  type = map(object({
    name                          = string
    location                      = string
    resource_group_name           = string
    sku                           = string
    admin_enabled                 = bool
    public_network_access_enabled = bool
    tags                          = map(string)
  }))
  description = "A map of Azure Container Registries to create"
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "The subnet ID where private endpoints will be created"
}

variable "acr_dns_zone_id" {
  type        = string
  description = "The private DNS zone ID for ACR"
}
