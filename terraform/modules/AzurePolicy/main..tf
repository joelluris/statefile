data "azurerm_subscription" "current" {}
data "azurerm_policy_definition" "Allowed_locations" {
  display_name = "Allowed locations"
}
data "azurerm_policy_definition" "Require_a_tag_on_rg" {
  display_name = "Require a tag on resource groups"
}
data "azurerm_policy_definition" "No_Public_IPs_on_NICs" {
  display_name = "Network interfaces should not have public IPs"
}
data "azurerm_policy_definition" "allowed_vm_skus" {
  display_name = "Allowed virtual machine size SKUs"
}
data "azurerm_policy_definition" "Audit_VM_AzureBackup" {
  display_name = "Azure Backup should be enabled for Virtual Machines"
}
data "azurerm_policy_definition" "Audit_VM_EncryptionatHost" {
  display_name = "Virtual machines and virtual machine scale sets should have encryption at host enabled"
}

data "azurerm_policy_definition" "disable_storage_account_public_access" {
  display_name = "Storage accounts should disable public network access"
}

data "azurerm_policy_definition" "deploy_monitor_agent" {
  display_name = "Windows virtual machines should have Azure Monitor Agent installed"
}

resource "azurerm_subscription_policy_assignment" "Allowed_locations" {
  name                 = var.Azure_Policy["Allowed_locations"]["Name"]
  display_name         = var.Azure_Policy["Allowed_locations"]["Name"]
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = data.azurerm_policy_definition.Allowed_locations.id
  parameters = jsonencode({
    "listOfAllowedLocations" : {
      "value" : var.Azure_Policy["Allowed_locations"]["Allowed_locations"],
    },
  })
}

resource "azurerm_subscription_policy_assignment" "Require_a_tag_on_rg" {
  for_each             = var.Azure_Policy_Require_a_tag_on_rg
  name                 = each.value.Name
  display_name         = each.value.Name
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = data.azurerm_policy_definition.Require_a_tag_on_rg.id
  parameters = jsonencode({
    "tagName" : {
      "value" : each.value.TagName
    }
  })
}

resource "azurerm_subscription_policy_assignment" "No_Public_IPs_on_NICs" {
  name                 = var.Azure_Policy["No_Public_IPs_on_NICs"]["Name"]
  display_name         = var.Azure_Policy["No_Public_IPs_on_NICs"]["Name"]
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = data.azurerm_policy_definition.No_Public_IPs_on_NICs.id

}

resource "azurerm_subscription_policy_assignment" "allowed_vm_skus" {
  name                 = var.Azure_Policy["allowed_vm_skus"]["Name"]
  display_name         = var.Azure_Policy["allowed_vm_skus"]["Name"]
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = data.azurerm_policy_definition.allowed_vm_skus.id

  parameters = jsonencode({
    listOfAllowedSKUs = {
      value = var.Azure_Policy["allowed_vm_skus"]["allowed_skus"]
    }
  })
}

resource "azurerm_subscription_policy_assignment" "Audit_VM_AzureBackup" {
  name                 = var.Azure_Policy["Audit_VM_AzureBackup"]["Name"]
  display_name         = var.Azure_Policy["Audit_VM_AzureBackup"]["Name"]
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = data.azurerm_policy_definition.Audit_VM_AzureBackup.id

  parameters = jsonencode({
    Effect = {
      value = "AuditIfNotExists"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "Audit_VM_EncryptionatHost" {
  name                 = var.Azure_Policy["Audit_VM_EncryptionatHost"]["Name"]
  display_name         = var.Azure_Policy["Audit_VM_EncryptionatHost"]["Name"]
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = data.azurerm_policy_definition.Audit_VM_EncryptionatHost.id

  parameters = jsonencode({
    Effect = {
      value = "Audit"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "deploy_monitor_agent" {
  name                 = "Deploy Azure Monitor Agent"
  policy_definition_id = data.azurerm_policy_definition.deploy_monitor_agent.id
  subscription_id      = data.azurerm_subscription.current.id
  description          = "Ensures Azure Monitor Agent is deployed to all VMs"
  display_name         = "Windows virtual machines should have Azure Monitor Agent installed"
}


resource "azurerm_subscription_policy_assignment" "disable_storage_account_public_access" {
  name                 = "disable-public-storage-network-access"
  policy_definition_id = data.azurerm_policy_definition.disable_storage_account_public_access.id
  subscription_id      = data.azurerm_subscription.current.id
  description          = "Prevents storage accounts from allowing public access"
  display_name         = "Storage accounts should disable public network access"
  parameters = jsonencode({
    Effect = {
      value = "Deny"
    }
  })
}
