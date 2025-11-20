variable "acr" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = string
    admin_enabled       = bool
    tags                = map(string)
  }))
  description = "A map of Azure Container Registries to create"
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "The subnet ID where private endpoints will be created"
}

variable "private_dns_zone_ids" {
  type        = map(string)
  description = "A map of private DNS zone IDs (key: acr, value: zone ID)"
}
