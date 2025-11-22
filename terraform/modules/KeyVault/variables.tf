variable "location" {}
variable "tenant_id" {}
variable "subscription_id" {}
variable "resource_group_output" {}
variable "private_endpoint_subnet_id" {}
variable "private_dns_zone_ids" {
  type = map(string)
}

variable "key_vault" {
  type = map(object({
    kv_name                       = string
    kv_rg_name                    = string
    sku                           = string
    purge_protection_enabled      = bool
    soft_delete_retention_days    = number
    public_network_access_enabled = bool
    tags                          = map(string)
  }))
}

variable "Arcon_PAM_IP" {
  type    = list(string)
  default = [
    "20.233.224.6/32",
    "4.161.34.11/32"
  ]
}
 
variable "umbrella_ip_range" {
  type    = list(string)
  default = [
    "155.190.0.0/16",
    "151.186.0.0/16",
    "146.112.0.0/16",
    "155.190.42.14/32"
  ]
}
 
variable "AzureDevopsrunner" {
  type    = list(string)
  default = [
    "4.161.33.244/32"  # Azure DevOps Runner IP
  ]
}


variable "soft_delete_enabled" {
  type = bool
  default = false
}

variable "disk_encryption_set_name" {
  type        = string
  description = "Name of the disk encryption set"
  default     = "des-kv-disk-encryption"
}

variable "key_vault_key_name" {
  type        = string
  description = "Name of the Key Vault key for disk encryption"
  default     = "disk-encryption-key"
}