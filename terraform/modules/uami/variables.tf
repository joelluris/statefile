variable "user_assigned_managed_identities" {
  description = "Map of User Assigned Managed Identities to create"
  type = map(object({
    name     = string
    rg_name  = string
    location = string
    role_assignments = map(object({
      role_definition_name = string
      scope_type           = string # resource_group, key_vault, user_assigned_managed_identity, azure_container_registry, storage_account
      scope                = string # Name of the resource (will be resolved to ID)
    }))
  }))
}

variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "rg_ids" {
  description = "Map of resource group names to IDs for scope resolution"
  type        = map(string)
  default     = {}
}

variable "key_vault_ids" {
  description = "Map of Key Vault names to IDs for scope resolution"
  type        = map(string)
  default     = {}
}

variable "storage_account_ids" {
  description = "Map of storage account names to IDs for scope resolution"
  type        = map(string)
  default     = {}
}

variable "acr_ids" {
  description = "Map of Azure Container Registry names to IDs for scope resolution"
  type        = map(string)
  default     = {}
}

variable "aks_ids" {
  type = map(string)
  default = {}
}