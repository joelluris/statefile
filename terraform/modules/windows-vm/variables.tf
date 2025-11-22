# Windows VM Module Variables

variable "windows_vms" {
  type = map(object({
    resource_group_name = string
    location            = string
    subnet_id           = string
    vm_name             = string
    vm_size             = string
    admin_username      = string
    os_disk_name        = string
    enable_public_ip    = optional(bool, false)
  }))
  description = "Map of Windows VMs to create"
}

variable "subnet_ids" {
  type        = map(string)
  description = "Map of subnet IDs for lookup"
  default     = {}
}

variable "key_vault_id" {
  type        = string
  description = "Key Vault ID to store the password"
}

variable "custom_data_script" {
  type        = string
  description = "Custom data script for VM initialization"
  default     = null
}

variable "disk_encryption_set_id" {
  type        = string
  description = "Disk encryption set ID"
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "Source image reference for the VM"
}

variable "os_disk" {
  type = object({
    storage_account_type = string
    caching              = string
    disk_size_gb         = number
  })
  description = "OS disk configuration"
}

variable "data_disk" {
  type = object({
    storage_account_type = string
    disk_size_gb         = number
    caching              = string
    lun                  = number
  })
  description = "Data disk configuration"
  default     = null
}

variable "extensions" {
  type = map(object({
    publisher            = string
    type                 = string
    type_handler_version = string
    settings             = optional(map(any))
    protected_settings   = optional(map(any))
  }))
  description = "Map of VM extensions to install on all VMs"
  default     = null
}

variable "win_vm" {
  type = object({
    enable_vm_extension = optional(bool, false)
    extension_command   = optional(string, "")
  })
  description = "Windows VM extension configuration"
  default = {
    enable_vm_extension = false
    extension_command   = ""
  }
}


