variable "location" {}
variable "tenant_id" {}
variable "subscription_id" {}
variable "resource_group_output" {}

variable "loganalytics" {
  type = map(object({
    name               = string
    resource_group_name = string
    sku                = string
    tags                         = map(string)
  }))
}
