variable "attempt_data_lookup_tenant_root_group" {
  description = "Whether the module should attempt to lookup the tenant root group"
  type        = bool
  default     = false
}

variable "policy_prefix" {
  type        = string
  description = "The prefix to apply to the custom policies"
  default     = "[Libre DevOps Custom]"
}

variable "policy_error_message_prefix" {
  type        = string
  description = "The prefix of the error messages across all policies"
  default     = "AzurePlatformPolicyError:"
}

variable "approved_resource_providers_policy" {
  description = "Configuration for the list of resource providers which can be deployed"
  type = object({
    name                           = optional(string, "approved-resource-providers")
    deploy_assignment              = optional(bool, true)
    management_group_id            = optional(string)
    enforce                        = optional(bool, true)
    non_compliance_message         = optional(string)
    description                    = optional(string)
    effect                         = optional(string, "Deny")
    management_group_ids_to_exempt = optional(list(string), [])
  })
}