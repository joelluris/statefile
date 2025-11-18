variable "project" {
  type     = string
  nullable = false

  validation {
    condition     = can(regex("^[a-z][a-z0-9]+$", var.project))
    error_message = "The project value must contain only alphanumerical characters."
  }
}

variable "environment" {
  type     = string
  nullable = false

  validation {
    condition     = can(regex("^(sbx|dev|tst|stg|prd|shd)$", var.environment))
    error_message = "The environment value must be one of the following: sbx, dev, tst, stg, prd, shd."
  }
}

variable "location" {
  type     = string
  nullable = false

  validation {
    condition     = can(regex("^(uksouth)$", var.location))
    error_message = "The location value must be one of the following: uksouth."
  }
}

variable "suffix" {
  type     = number
  nullable = false

  validation {
    condition     = var.suffix >= 1
    error_message = "The suffix value must be greater than or equal to 1."
  }
}

variable "resource_group_id" {
  type     = string
  nullable = false

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/rg-[^/]+$", var.resource_group_id))
    error_message = "The resource group id value must be a valid resource group id, starting with \"rg-\"."
  }
}

variable "subnet_id" {
  type     = string
  nullable = false

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/virtualNetworks/[^/]+/subnets/snet-[^/]+$", var.subnet_id))
    error_message = "The subnet id value must be a valid subnet id, starting with \"snet-\"."
  }
}

variable "private_dns_zone_id" {
  type     = string
  nullable = false

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/privateDnsZones/[^/]+$", var.private_dns_zone_id))
    error_message = "The private dns zone id value must be a valid private dns zone id."
  }
}

variable "containers" {
  type = list(object({
    name         = string
    contributors = map(string)
  }))
  nullable = false

  validation {
    condition     = length(distinct(var.containers[*].name)) == length(var.containers)
    error_message = "The containers value must contain unique names."
  }
}

variable "log_analytics_workspace_id" {
  type = string

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.OperationalInsights/workspaces/law-[^/]+$", var.log_analytics_workspace_id))
    error_message = "The log analytics workspace id value must be a valid log analytics workspace id, starting with \"law-\"."
  }
}
