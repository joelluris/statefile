variable "automation_accounts" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku_name            = string
    tags                = map(string)
  }))
  description = "Map of automation accounts to create"
}

variable "runbooks" {
  type = map(object({
    name                    = string
    automation_account_key  = string
    resource_group_name     = string
    location                = string
    runbook_type            = string
    log_verbose             = bool
    log_progress            = bool
    description             = string
    content                 = string
  }))
  description = "Map of runbooks to create"
  default     = {}
}

variable "schedules" {
  type = map(object({
    name                    = string
    automation_account_key  = string
    resource_group_name     = string
    frequency               = string
    interval                = number
    timezone                = string
    start_time              = string
    description             = string
    week_days               = optional(list(string))
  }))
  description = "Map of schedules for automation account"
  default     = {}
}

variable "job_schedules" {
  type = map(object({
    automation_account_key = string
    resource_group_name    = string
    runbook_name           = string
    schedule_name          = string
    parameters             = optional(map(string))
  }))
  description = "Map of job schedules linking runbooks to schedules"
  default     = {}
}