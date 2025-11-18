variable "location" {}
variable "tenant_id" {}
variable "subscription_id" {}
variable "Azure_Policy" {
  type = map(object({
    Name              = string
    Allowed_locations = optional(list(string))
    allowed_skus      = optional(list(string))
  }))
}

variable "Azure_Policy_Require_a_tag_on_rg" {
  type = map(object({
    Name    = string
    TagName = optional(string)
  }))
}
