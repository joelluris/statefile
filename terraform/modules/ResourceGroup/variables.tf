variable "location" {}
variable "tenant_id" {}
variable "subscription_id" {}
variable "all_resource_groups" {
  type = map(object({
    name = string
    tags = map(string)
  }))
}
