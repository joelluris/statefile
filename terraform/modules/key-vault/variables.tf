variable "location" {
  type        = string
  description = "The location/region where the UAMIs will be created"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to the Key Vault"
  default     = {}
}

variable "private_dns_zone_id" {
  type        = string
  description = "The ID of the private DNS zone for Key Vault"
}

variable "key_vault_name" {
  type = string
  description = "The name of the Azure Key Vault"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the Key Vault private endpoint"
}

variable "key_vault_key_name" {
  type        = string
  description = "The name of the Key Vault key"
}

variable "disk_encryption_set_name" {
  type = string
  description = "The name of the disck encryption set"
}