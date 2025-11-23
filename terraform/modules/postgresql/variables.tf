variable "postgresql" {
  description = "Map of PostgreSQL configurations for password generation"
  type = map(object({
    name = string
  }))
  default = {}
}

variable "postgresql_servers" {
  description = "Map of PostgreSQL Flexible Servers to create"
  type = map(object({
    name                   = string
    resource_group_name    = string
    location               = string
    sku_name               = string
    version                = string
    storage_mb             = number
    backup_retention_days  = number
    geo_redundant_backup   = bool
    administrator_login    = string
    ssl_enforcement        = bool
    delegated_subnet_id    = optional(string)
    private_dns_zone_id    = optional(string)
    high_availability      = optional(object({
      mode                      = string
      standby_availability_zone = optional(string)
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "postgresql_databases" {
  description = "Map of PostgreSQL databases to create"
  type = map(object({
    name       = string
    server_key = string
    charset    = optional(string, "UTF8")
    collation  = optional(string, "en_US.utf8")
  }))
  default = {}
}

variable "postgresql_firewall_rules" {
  description = "Map of PostgreSQL firewall rules"
  type = map(object({
    name             = string
    server_key       = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default = {}
}

variable "postgresql_virtual_network_rules" {
  description = "Map of PostgreSQL virtual network rules"
  type = map(object({
    name       = string
    server_key = string
    subnet_id  = string
  }))
  default = {}
}

variable "key_vault_id" {
  description = "Key Vault ID for storing PostgreSQL passwords"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Map of subnet IDs from VirtualNetwork module"
  type        = map(string)
  default     = {}
}

variable "postgresql_dns_zone_id" {
  description = "PostgreSQL Private DNS Zone ID"
  type        = string
  default     = null
}