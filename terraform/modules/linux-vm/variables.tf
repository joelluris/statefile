variable "linux_vms" {
  description = "Map of Linux VMs to create"
  type = map(object({
    vm_name             = string
    location            = string
    resource_group_name = string
    vm_size             = string
    admin_username      = string
    subnet_id           = string
    os_disk_name        = string
    enable_public_ip    = optional(bool, false)
    tags                = optional(map(string), {})
  }))
}

variable "subnet_ids" {
  description = "Map of subnet IDs for dynamic lookup"
  type        = map(string)
}

variable "key_vault_id" {
  description = "Key Vault ID to store SSH keys"
  type        = string
}

variable "disk_encryption_set_id" {
  description = "Disk encryption set ID for disk encryption"
  type        = string
}

variable "custom_data_script" {
  description = "Optional custom data script for VM initialization"
  type        = string
  default     = null
}

variable "source_image_reference" {
  description = "Source image reference for Linux VMs"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "os_disk" {
  description = "OS disk configuration"
  type = object({
    caching              = string
    storage_account_type = string
    disk_size_gb         = number
  })
}

variable "data_disk" {
  description = "Data disk configuration (optional)"
  type = object({
    storage_account_type = string
    disk_size_gb         = number
    lun                  = number
    caching              = string
  })
  default = null
}

variable "linux_vm" {
  description = "Linux VM specific configuration"
  type = object({
    disable_password_authentication = bool
  })
  default = {
    disable_password_authentication = true
  }
}

variable "extensions" {
  description = "VM extensions to install"
  type = map(object({
    publisher            = string
    type                 = string
    type_handler_version = string
    settings             = optional(map(any))
    protected_settings   = optional(map(any))
  }))
  default = null
}
