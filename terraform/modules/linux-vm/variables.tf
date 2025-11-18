# # Linux VM Module Variables

# variable "linux_vms" {
#   type = map(object({
#     vm_name        = string
#     vm_size        = string
#     admin_username = string
#     os_disk_name   = string
#   }))
#   description = "Map of Linux VMs to create"
# }

# variable "location" {
#   type        = string
#   description = "Azure region for the VM"
# }

# variable "resource_group_name" {
#   type        = string
#   description = "Resource group name"
# }

# variable "subnet_id" {
#   type        = string
#   description = "Subnet ID for the VM NIC"
# }

# variable "key_vault_id" {
#   type        = string
#   description = "Key Vault ID to store the password"
# }

# variable "custom_data_script" {
#   type        = string
#   description = "Custom data script for VM initialization"
#   default     = null
# }

# variable "disk_encryption_set_id" {
#   type        = string
#   description = "Disk encryption set ID"
# }

# variable "source_image_reference" {
#   type = object({
#     publisher = string
#     offer     = string
#     sku       = string
#     version   = string
#   })
#   description = "Source image reference for the VM"
# }

# variable "os_disk" {
#   type = object({
#     storage_account_type = string
#     caching              = string
#     disk_size_gb         = number
#   })
#   description = "OS disk configuration"
# }

# variable "data_disk" {
#   type = object({
#     storage_account_type = string
#     disk_size_gb         = number
#     caching              = string
#     lun                  = number
#   })
#   description = "Data disk configuration"
#   default     = null
# }

# variable "disable_password_authentication" {
#   type        = bool
#   description = "Whether to disable password authentication and use SSH keys only"
#   default     = true
# }

# variable "ssh_public_key" {
#   type        = string
#   description = "SSH public key for authentication (required if password authentication is disabled)"
#   default     = null
# }

# variable "extensions" {
#   type = map(object({
#     publisher            = string
#     type                 = string
#     type_handler_version = string
#     settings             = optional(map(any))
#     protected_settings   = optional(map(any))
#   }))
#   description = "Map of VM extensions to install on all VMs"
#   default     = null
# }

# variable "tags" {
#   type        = map(string)
#   description = "Tags to apply to resources"
# }
