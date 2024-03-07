variable "add_resource_lock_to_nsg_policy" {
  description = "Configuration for policy which adds a resource lock to all NSGs"
  type = object({
    name                    = optional(string, "add-nsg-lock")
    deploy_assignment       = optional(bool, true)
    management_group_id     = optional(string)
    attempt_role_assignment = optional(bool, true)
    enforce                 = optional(bool, true)
    location                = optional(string, "uksouth")
    role_definition_id      = optional(string, "/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635")
    non_compliance_message  = optional(string)
    description             = optional(string)
  })
}

variable "allowed_resources_policy" {
  description = "Configuration for the list of resource providers which can be deployed"
  type = object({
    name                          = optional(string, "approved-resources-providers")
    additional_resource_providers = optional(list(string), [])
    approved_resources = optional(list(string), [
      "microsoft.advisor",
      "microsoft.alertsmanagement/smartdetectoralertrules",
      "microsoft.authorization/locks",
      "microsoft.automation/automationaccounts",
      "microsoft.compute/disks",
      "microsoft.compute/galleries/images",
      "microsoft.compute/sshpublickeys",
      "microsoft.compute/virtualmachines",
      "microsoft.compute/virtualmachines/extensions",
      "microsoft.insights/actiongroups",
      "microsoft.insights/components",
      "microsoft.insights/workbooks",
      "microsoft.keyvault/vaults",
      "microsoft.logic/workflows",
      "microsoft.managedidentity/userassignedidentities",
      "microsoft.network/applicationsecuritygroups",
      "microsoft.network/bastionhosts",
      "microsoft.network/connections",
      "microsoft.network/networkinterfaces",
      "microsoft.network/networksecuritygroups",
      "microsoft.network/networkwatchers",
      "microsoft.network/privatednszones",
      "microsoft.network/privatednszones/virtualnetworklinks",
      "microsoft.network/publicipaddresses",
      "microsoft.network/virtualnetworks",
      "microsoft.resourcehealth/availabilitystatuses",
      "microsoft.resourcehealth/childavailabilitystatuses",
      "microsoft.resourcehealth/childresources",
      "microsoft.resourcehealth/emergingissues",
      "microsoft.resourcehealth/events",
      "microsoft.resourcehealth/impactedresources",
      "microsoft.resourcehealth/metadata",
      "microsoft.resourcehealth/operations",
      "microsoft.resources/batch",
      "microsoft.resources/builtintemplatespecs",
      "microsoft.resources/builtintemplatespecs/versions",
      "microsoft.resources/bulkdelete",
      "microsoft.resources/calculatetemplatehash",
      "microsoft.resources/changes",
      "microsoft.resources/checkpolicycompliance",
      "microsoft.resources/checkresourcename",
      "microsoft.resources/checkzonepeers",
      "microsoft.resources/deployments",
      "microsoft.resources/deployments/operations",
      "microsoft.resources/deploymentscripts",
      "microsoft.resources/deploymentscripts/logs",
      "microsoft.resources/deploymentstacks",
      "microsoft.resources/deploymentstacks/snapshots",
      "microsoft.resources/links",
      "microsoft.resources/locations",
      "microsoft.resources/locations/batchoperationresults",
      "microsoft.resources/locations/batchoperationstatuses",
      "microsoft.resources/locations/deploymentscriptoperationresults",
      "microsoft.resources/locations/deploymentstackoperationstatus",
      "microsoft.resources/mobobrokers",
      "microsoft.resources/notifyresourcejobs",
      "microsoft.resources/operationresults",
      "microsoft.resources/operations",
      "microsoft.resources/providers",
      "microsoft.resources/resourcegroups",
      "microsoft.resources/resources",
      "microsoft.resources/snapshots",
      "microsoft.resources/subscriptions",
      "microsoft.resources/subscriptions/locations",
      "microsoft.resources/subscriptions/operationresults",
      "microsoft.resources/subscriptions/providers",
      "microsoft.resources/subscriptions/resourcegroups",
      "microsoft.resources/subscriptions/resourcegroups/resources",
      "microsoft.resources/subscriptions/resources",
      "microsoft.resources/subscriptions/tagnames",
      "microsoft.resources/subscriptions/tagnames/tagvalues",
      "microsoft.resources/tagnamespaceoperationresults",
      "microsoft.resources/tagnamespaces",
      "microsoft.resources/tags",
      "microsoft.resources/templatespecs",
      "microsoft.resources/templatespecs/versions",
      "microsoft.resources/tenants",
      "microsoft.resources/validateresources",
      "microsoft.security/automations",
      "microsoft.storage/storageaccounts",
      "microsoft.support/checknameavailability",
      "microsoft.support/fileworkspaces",
      "microsoft.support/fileworkspaces/files",
      "microsoft.support/lookupresourceid",
      "microsoft.support/operationresults",
      "microsoft.support/operations",
      "microsoft.support/operationsstatus",
      "microsoft.support/services",
      "microsoft.support/services/problemclassifications",
      "microsoft.support/supporttickets",
      "microsoft.support/supporttickets/communications",
    ])
    deploy_assignment              = optional(bool, true)
    management_group_id            = optional(string)
    enforce                        = optional(bool, true)
    non_compliance_message         = optional(string)
    description                    = optional(string)
    effect                         = optional(string, "Deny")
    management_group_ids_to_exempt = optional(list(string), [])
  })
}

variable "append_default_deny_nsg_rule_policy" {
  description = "Configuration for append deny NSG rule deployment policy"
  type = object({
    name                         = optional(string, "append-nsg-default-deny1")
    deploy_assignment            = optional(bool, true)
    nsg_rule_name                = optional(string, "DenyAnyInbound")
    management_group_id          = optional(string)
    enforce                      = optional(bool, true)
    non_compliance_message       = optional(string)
    description                  = optional(string)
    effect                       = optional(string, "Append")
    protocol                     = optional(string, "*")
    access                       = optional(string, "Deny")
    name_suffix                  = optional(string, "*")
    priority                     = optional(string, "4096")
    direction                    = optional(string, "Inbound")
    source_port_ranges           = optional(list(string), ["*"])
    destination_port_ranges      = optional(list(string), ["*"])
    source_address_prefixes      = optional(list(string), ["*"])
    destination_address_prefixes = optional(list(string), ["*"])
  })
}

variable "attempt_read_tenant_root_group" {
  type        = bool
  default     = true
  description = "Whether the module should attempt to read the tenant root group, your SPN may not have permissions"
}

variable "deny_nsg_deletion_action_policy" {
  description = "Configuration for DenyAction policy for NSG"
  type = object({
    name                   = optional(string, "deny-nsg-delete")
    deploy_assignment      = optional(bool, true)
    management_group_id    = optional(string)
    enforce                = optional(bool, true)
    non_compliance_message = optional(string)
    description            = optional(string)
  })
}

variable "like_mandatory_resource_tagging_policy" {
  description = "Configuration for the mandatory resource tagging policy for the like"
  type = object({
    name                   = optional(string, "like-mandatory-tags")
    deploy_assignment      = optional(bool, true)
    management_group_id    = optional(string)
    enforce                = optional(bool, true)
    non_compliance_message = optional(string)
    description            = optional(string)
    effect                 = optional(string, "Audit")
    required_tags = list(object({
      key     = string
      pattern = string
    }))
  })
}

variable "match_mandatory_resource_tagging_policy" {
  description = "Configuration for the mandatory resource tagging policy for the match pattern"
  type = object({
    name                   = optional(string, "match-mandatory-tags")
    deploy_assignment      = optional(bool, true)
    management_group_id    = optional(string)
    enforce                = optional(bool, true)
    non_compliance_message = optional(string)
    description            = optional(string)
    effect                 = optional(string, "Audit")
    required_tags = list(object({
      key     = string
      pattern = string
    }))
  })
}

variable "non_privileged_role_restriction_policy" {
  description = "Configuration for the non privileged role restriction policy, this policy allows you to restrict specific role definition IDs to specific principal types, in the event you would like users to have different access to other things like Managed Identities (normally used in automation)"
  type = object({
    name                                                      = optional(string, "restrict-roles-for-non-privileged")
    management_group_id                                       = optional(string)
    deploy_assignment                                         = optional(bool, true)
    enforce                                                   = optional(bool, true)
    non_compliance_message                                    = optional(string)
    description                                               = optional(string)
    effect                                                    = optional(string, "Audit")
    non_privileged_role_definition_ids                        = optional(list(string), [])
    non_privileged_role_definition_restricted_principal_types = optional(list(string), ["User", "Group"])
  })
}

variable "policy_error_prefix" {
  type        = string
  description = "The prefix to apply to custom policies"
  default     = "[PlatformPolicyException]:"
}

variable "policy_prefix" {
  type        = string
  description = "The prefix to apply to the custom policies"
  default     = "[LibreDevOps Custom]"
}

variable "privileged_role_restriction_policy" {
  description = "Configuration for the role restriction policy, this policy allows you to restrict specific role definition IDs to specific principal types, in the event you would like users to have different access to other things like Managed Identities (normally used in automation)"
  type = object({
    name                           = optional(string, "restrict-roles-for-principal-type")
    management_group_id            = optional(string)
    deploy_assignment              = optional(bool, true)
    enforce                        = optional(bool, true)
    non_compliance_message         = optional(string)
    description                    = optional(string)
    effect                         = optional(string, "Audit")
    privileged_role_definition_ids = optional(list(string), [])
    privileged_role_definition_restricted_principal_types = optional(list(string), [
      "ServicePrincipal", "ManagedIdentity", "Application"
    ])
  })
}
