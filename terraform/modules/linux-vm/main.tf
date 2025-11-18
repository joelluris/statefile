# # ==========================================================================================
# # Linux VM Module
# # - Creates multiple Linux virtual machines with encrypted disks
# # - Stores admin passwords in Key Vault
# # - Configures network interfaces
# # - Supports SSH key authentication
# # ==========================================================================================

# data "azurerm_client_config" "current" {}

# resource "random_password" "vm_passwords" {
#   for_each = var.linux_vms

#   length      = 24
#   min_lower   = 3
#   min_upper   = 3
#   min_numeric = 3
#   min_special = 3
# }

# # Store admin password in Key Vault for each VM
# resource "azurerm_key_vault_secret" "vm_admin_password" {
#   for_each = var.linux_vms

#   name         = "${each.key}-admin-password"
#   value        = random_password.vm_passwords[each.key].result
#   key_vault_id = var.key_vault_id

#   tags = var.tags
# }

# # Network Interface for each VM
# resource "azurerm_network_interface" "vm_nic" {
#   for_each = var.linux_vms

#   name                = "nic-${each.value.vm_name}"
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   ip_configuration {
#     name                          = "ipconfig-${each.value.vm_name}"
#     subnet_id                     = var.subnet_id
#     private_ip_address_allocation = "Dynamic"
#   }

#   tags = var.tags
# }

# # Linux Virtual Machine for each VM
# resource "azurerm_linux_virtual_machine" "vm" {
#   for_each = var.linux_vms

#   name                            = each.value.vm_name
#   location                        = var.location
#   resource_group_name             = var.resource_group_name
#   size                            = each.value.vm_size
#   admin_username                  = each.value.admin_username
#   disable_password_authentication = var.disable_password_authentication

#   network_interface_ids = [
#     azurerm_network_interface.vm_nic[each.key].id
#   ]

#   # SSH key configuration (required if password authentication is disabled)
#   dynamic "admin_ssh_key" {
#     for_each = var.disable_password_authentication ? [1] : []
#     content {
#       username   = each.value.admin_username
#       public_key = var.ssh_public_key
#     }
#   }

#   # Password authentication (if enabled)
#   admin_password = var.disable_password_authentication ? null : random_password.vm_passwords[each.key].result

#   os_disk {
#     name                   = each.value.os_disk_name
#     caching                = var.os_disk.caching
#     storage_account_type   = var.os_disk.storage_account_type
#     disk_size_gb           = var.os_disk.disk_size_gb
#     disk_encryption_set_id = var.disk_encryption_set_id
#   }

#   source_image_reference {
#     publisher = var.source_image_reference.publisher
#     offer     = var.source_image_reference.offer
#     sku       = var.source_image_reference.sku
#     version   = var.source_image_reference.version
#   }

#   # Optional custom data for initial configuration
#   custom_data = var.custom_data_script != null ? base64encode(var.custom_data_script) : null

#   identity {
#     type = "SystemAssigned"
#   }

#   patch_assessment_mode = "AutomaticByPlatform"

#   tags = var.tags

#   lifecycle {
#     ignore_changes = [
#       custom_data
#     ]
#   }
# }

# # Managed Data Disk for each VM
# resource "azurerm_managed_disk" "data_disk" {
#   for_each = var.data_disk != null ? var.linux_vms : {}

#   name                   = "datadisk-${each.value.vm_name}"
#   location               = var.location
#   resource_group_name    = var.resource_group_name
#   storage_account_type   = var.data_disk.storage_account_type
#   create_option          = "Empty"
#   disk_size_gb           = var.data_disk.disk_size_gb
#   disk_encryption_set_id = var.disk_encryption_set_id

#   tags = var.tags
# }

# # Attach Data Disk to VM
# resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
#   for_each = var.data_disk != null ? var.linux_vms : {}

#   managed_disk_id    = azurerm_managed_disk.data_disk[each.key].id
#   virtual_machine_id = azurerm_linux_virtual_machine.vm[each.key].id
#   lun                = var.data_disk.lun
#   caching            = var.data_disk.caching
# }

# # VM Extensions - Multiple extensions per VM
# resource "azurerm_virtual_machine_extension" "vm_extensions" {
#   for_each = var.extensions != null ? {
#     for pair in flatten([
#       for vm_key, vm in var.linux_vms : [
#         for ext_key, ext in var.extensions : {
#           key                  = "${vm_key}-${ext_key}"
#           vm_key               = vm_key
#           ext_key              = ext_key
#           vm_name              = vm.vm_name
#           publisher            = ext.publisher
#           type                 = ext.type
#           type_handler_version = ext.type_handler_version
#           settings             = lookup(ext, "settings", null)
#           protected_settings   = lookup(ext, "protected_settings", null)
#         }
#       ]
#     ]) : pair.key => pair
#   } : {}

#   name                       = "${each.value.vm_name}-${each.value.type}"
#   virtual_machine_id         = azurerm_linux_virtual_machine.vm[each.value.vm_key].id
#   publisher                  = each.value.publisher
#   type                       = each.value.type
#   type_handler_version       = each.value.type_handler_version
#   auto_upgrade_minor_version = true

#   settings           = each.value.settings != null ? jsonencode(each.value.settings) : null
#   protected_settings = each.value.protected_settings != null ? jsonencode(each.value.protected_settings) : null

#   tags = var.tags
# }
