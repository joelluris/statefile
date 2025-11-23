variable "location" {}
variable "tenant_id" {}
variable "subscription_id" {}
variable "resource_group_output" {}
variable "BackupVault" {
  description = "A map of Recovery Services Vault configurations"
  type        = map(object({
    rsv_vault_name           = string
    location                 = string
    rsv_resource_group_name  = string
    rsv_vault_sku            = string
    soft_delete_enabled      = bool
    tags                         = map(string)
  }))
}

variable "BackupPolicy" {
  description = "A map of backup policy configurations"
  type        = map(object({
    backup_policy_name              = string
    rsv_resource_group_name         = string
    rsv_vault_name                  = string
    timezone                        = string
    instant_restore_retention_days  = number
    backup_frequency                = string
    backup_time                     = string
    retention_daily                 = number
    retention_weekly                = number
    retention_weekly_days           = list(string)
    retention_monthly               = number
    retention_monthly_week          = list(string)
    retention_monthly_days          = list(string)
    retention_yearly                = number
    retention_yearly_month          = list(string)
    retention_yearly_week           = list(string)
    retention_yearly_days           = list(string)
  }))
}

variable "protected_vms" {
  description = "A map of VMs to protect with backup"
  type = map(object({
    rsv_resource_group_name = string
    rsv_vault_name          = string
    vm_key                  = string  # Key from windows_vm module
    backup_policy_key       = string
  }))
  default = {}
}

variable "vm_ids" {
  description = "Map of VM keys to their resource IDs from windows_vm module"
  type        = map(string)
  default     = {}
}
