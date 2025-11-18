# variable "workloads" {
#   type        = list(string)
#   description = "The name segment for the workload"
#   nullable = false
#   validation {
#     # - Returns true only if all elements in the list evaluate to true.
#     condition     = alltrue([for w in var.workloads : can(regex("^(rg|vm|aks|snet|acr|kv|api)$", w))])
#     error_message = "The name segment for the workload must be one of the following: rg, vm, aks, snet, acr, kv, api"
#   }
# }

# variable "project_code" {
#   type        = string
#   description = "The name segment for the project"
#   default     = "lnt-eip"
#   validation {
#     condition     = can(regex("^[a-z0-9-]+$", var.project_code))
#     error_message = "The name segment for the project must only contain lowercase letters, numbers and hyphens"
#   }
#   validation {
#     condition     = length(var.project_code) <= 8
#     error_message = "The name segment for the project must be 8 characters or less"
#   }
# }

# variable "environment" {
#   type        = string
#   description = "The name segment for the environment"
#   default     = "nonprod"
#   validation {
#     condition     = can(regex("^[a-z0-9]+$", var.environment))
#     error_message = "The name segment for the environment must only contain lowercase letters and numbers"
#   }
#   validation {
#     condition     = length(var.environment) <= 7
#     error_message = "The name segment for the environment must be 7 characters or less"
#   }
# }

# variable "location" {
#   type        = string
#   description = "The location/region where the resources will be created. Must be in the short form (e.g. 'uaenorth')"
#   validation {
#     condition     = can(regex("^(uaenorth)", var.location))
#     error_message = "The location must only contain lowercase letters, numbers, and hyphens and uaenorth"
#   }
#   validation {
#     condition     = length(var.location) <= 20
#     error_message = "The location must be 20 characters or less"
#   }
# }

# variable "resource_name_sequence_start" {
#   type        = number
#   description = "The number to use for the resource names"
#   default     = 1
#   validation {
#     condition     = var.resource_name_sequence_start >= 1 && var.resource_name_sequence_start <= 999
#     error_message = "The number must be between 1 and 999"
#   }
# }

# variable "tags" {
#   type = map(string)
#   description = "Tags to apply"
# }