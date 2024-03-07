```hcl
#
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_management_group_policy_assignment.add_resource_lock_to_nsg_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_assignment.append_default_deny_nsg_rule_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_assignment.approved_resource_providers_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_assignment.approved_services_actions_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_assignment.deny_nsg_deletion_action_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_assignment.like_mandatory_resource_tagging](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_assignment.match_mandatory_resource_tagging](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_assignment.non_privileged_role_restriction_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_assignment.privileged_role_restriction_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_policy_definition.add_resource_lock_to_nsg_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.append_default_deny_nsg_rule_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.approved_resources_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.deny_nsg_deletion_action_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.like_mandatory_resource_tagging_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.match_mandatory_resource_tagging_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.non_privileged_role_restriction_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.privileged_role_restriction_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_role_assignment.add_resource_lock_to_nsg_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_management_group.tenant_root_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |
| [azurerm_policy_definition_built_in.allowed_resource_types](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/policy_definition_built_in) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_resource_lock_to_nsg_policy"></a> [add\_resource\_lock\_to\_nsg\_policy](#input\_add\_resource\_lock\_to\_nsg\_policy) | Configuration for policy which adds a resource lock to all NSGs | <pre>object({<br>    name                    = optional(string, "add-nsg-lock")<br>    deploy_assignment       = optional(bool, true)<br>    management_group_id     = optional(string)<br>    attempt_role_assignment = optional(bool, true)<br>    enforce                 = optional(bool, true)<br>    location                = optional(string, "uksouth")<br>    role_definition_id      = optional(string, "/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635")<br>    non_compliance_message  = optional(string)<br>    description             = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_allowed_resources_policy"></a> [allowed\_resources\_policy](#input\_allowed\_resources\_policy) | Configuration for the list of resource providers which can be deployed | <pre>object({<br>    name                          = optional(string, "approved-resources-providers")<br>    additional_resource_providers = optional(list(string), [])<br>    approved_resources = optional(list(string), [<br>      "microsoft.advisor",<br>      "microsoft.alertsmanagement/smartdetectoralertrules",<br>      "microsoft.authorization/locks",<br>      "microsoft.automation/automationaccounts",<br>      "microsoft.compute/disks",<br>      "microsoft.compute/galleries/images",<br>      "microsoft.compute/sshpublickeys",<br>      "microsoft.compute/virtualmachines",<br>      "microsoft.compute/virtualmachines/extensions",<br>      "microsoft.insights/actiongroups",<br>      "microsoft.insights/components",<br>      "microsoft.insights/workbooks",<br>      "microsoft.keyvault/vaults",<br>      "microsoft.logic/workflows",<br>      "microsoft.managedidentity/userassignedidentities",<br>      "microsoft.network/applicationsecuritygroups",<br>      "microsoft.network/bastionhosts",<br>      "microsoft.network/connections",<br>      "microsoft.network/networkinterfaces",<br>      "microsoft.network/networksecuritygroups",<br>      "microsoft.network/networkwatchers",<br>      "microsoft.network/privatednszones",<br>      "microsoft.network/privatednszones/virtualnetworklinks",<br>      "microsoft.network/publicipaddresses",<br>      "microsoft.network/virtualnetworks",<br>      "microsoft.resourcehealth/availabilitystatuses",<br>      "microsoft.resourcehealth/childavailabilitystatuses",<br>      "microsoft.resourcehealth/childresources",<br>      "microsoft.resourcehealth/emergingissues",<br>      "microsoft.resourcehealth/events",<br>      "microsoft.resourcehealth/impactedresources",<br>      "microsoft.resourcehealth/metadata",<br>      "microsoft.resourcehealth/operations",<br>      "microsoft.resources/batch",<br>      "microsoft.resources/builtintemplatespecs",<br>      "microsoft.resources/builtintemplatespecs/versions",<br>      "microsoft.resources/bulkdelete",<br>      "microsoft.resources/calculatetemplatehash",<br>      "microsoft.resources/changes",<br>      "microsoft.resources/checkpolicycompliance",<br>      "microsoft.resources/checkresourcename",<br>      "microsoft.resources/checkzonepeers",<br>      "microsoft.resources/deployments",<br>      "microsoft.resources/deployments/operations",<br>      "microsoft.resources/deploymentscripts",<br>      "microsoft.resources/deploymentscripts/logs",<br>      "microsoft.resources/deploymentstacks",<br>      "microsoft.resources/deploymentstacks/snapshots",<br>      "microsoft.resources/links",<br>      "microsoft.resources/locations",<br>      "microsoft.resources/locations/batchoperationresults",<br>      "microsoft.resources/locations/batchoperationstatuses",<br>      "microsoft.resources/locations/deploymentscriptoperationresults",<br>      "microsoft.resources/locations/deploymentstackoperationstatus",<br>      "microsoft.resources/mobobrokers",<br>      "microsoft.resources/notifyresourcejobs",<br>      "microsoft.resources/operationresults",<br>      "microsoft.resources/operations",<br>      "microsoft.resources/providers",<br>      "microsoft.resources/resourcegroups",<br>      "microsoft.resources/resources",<br>      "microsoft.resources/snapshots",<br>      "microsoft.resources/subscriptions",<br>      "microsoft.resources/subscriptions/locations",<br>      "microsoft.resources/subscriptions/operationresults",<br>      "microsoft.resources/subscriptions/providers",<br>      "microsoft.resources/subscriptions/resourcegroups",<br>      "microsoft.resources/subscriptions/resourcegroups/resources",<br>      "microsoft.resources/subscriptions/resources",<br>      "microsoft.resources/subscriptions/tagnames",<br>      "microsoft.resources/subscriptions/tagnames/tagvalues",<br>      "microsoft.resources/tagnamespaceoperationresults",<br>      "microsoft.resources/tagnamespaces",<br>      "microsoft.resources/tags",<br>      "microsoft.resources/templatespecs",<br>      "microsoft.resources/templatespecs/versions",<br>      "microsoft.resources/tenants",<br>      "microsoft.resources/validateresources",<br>      "microsoft.security/automations",<br>      "microsoft.storage/storageaccounts",<br>      "microsoft.support/checknameavailability",<br>      "microsoft.support/fileworkspaces",<br>      "microsoft.support/fileworkspaces/files",<br>      "microsoft.support/lookupresourceid",<br>      "microsoft.support/operationresults",<br>      "microsoft.support/operations",<br>      "microsoft.support/operationsstatus",<br>      "microsoft.support/services",<br>      "microsoft.support/services/problemclassifications",<br>      "microsoft.support/supporttickets",<br>      "microsoft.support/supporttickets/communications",<br>    ])<br>    deploy_assignment              = optional(bool, true)<br>    management_group_id            = optional(string)<br>    enforce                        = optional(bool, true)<br>    non_compliance_message         = optional(string)<br>    description                    = optional(string)<br>    effect                         = optional(string, "Deny")<br>    management_group_ids_to_exempt = optional(list(string), [])<br>  })</pre> | n/a | yes |
| <a name="input_append_default_deny_nsg_rule_policy"></a> [append\_default\_deny\_nsg\_rule\_policy](#input\_append\_default\_deny\_nsg\_rule\_policy) | Configuration for append deny NSG rule deployment policy | <pre>object({<br>    name                         = optional(string, "append-nsg-default-deny1")<br>    deploy_assignment            = optional(bool, true)<br>    nsg_rule_name                = optional(string, "DenyAnyInbound")<br>    management_group_id          = optional(string)<br>    enforce                      = optional(bool, true)<br>    non_compliance_message       = optional(string)<br>    description                  = optional(string)<br>    effect                       = optional(string, "Append")<br>    protocol                     = optional(string, "*")<br>    access                       = optional(string, "Deny")<br>    name_suffix                  = optional(string, "*")<br>    priority                     = optional(string, "4096")<br>    direction                    = optional(string, "Inbound")<br>    source_port_ranges           = optional(list(string), ["*"])<br>    destination_port_ranges      = optional(list(string), ["*"])<br>    source_address_prefixes      = optional(list(string), ["*"])<br>    destination_address_prefixes = optional(list(string), ["*"])<br>  })</pre> | n/a | yes |
| <a name="input_attempt_read_tenant_root_group"></a> [attempt\_read\_tenant\_root\_group](#input\_attempt\_read\_tenant\_root\_group) | Whether the module should attempt to read the tenant root group, your SPN may not have permissions | `bool` | `true` | no |
| <a name="input_deny_nsg_deletion_action_policy"></a> [deny\_nsg\_deletion\_action\_policy](#input\_deny\_nsg\_deletion\_action\_policy) | Configuration for DenyAction policy for NSG | <pre>object({<br>    name                   = optional(string, "deny-nsg-delete")<br>    deploy_assignment      = optional(bool, true)<br>    management_group_id    = optional(string)<br>    enforce                = optional(bool, true)<br>    non_compliance_message = optional(string)<br>    description            = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_like_mandatory_resource_tagging_policy"></a> [like\_mandatory\_resource\_tagging\_policy](#input\_like\_mandatory\_resource\_tagging\_policy) | Configuration for the mandatory resource tagging policy for the like | <pre>object({<br>    name                   = optional(string, "like-mandatory-tags")<br>    deploy_assignment      = optional(bool, true)<br>    management_group_id    = optional(string)<br>    enforce                = optional(bool, true)<br>    non_compliance_message = optional(string)<br>    description            = optional(string)<br>    effect                 = optional(string, "Audit")<br>    required_tags = list(object({<br>      key     = string<br>      pattern = string<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_match_mandatory_resource_tagging_policy"></a> [match\_mandatory\_resource\_tagging\_policy](#input\_match\_mandatory\_resource\_tagging\_policy) | Configuration for the mandatory resource tagging policy for the match pattern | <pre>object({<br>    name                   = optional(string, "match-mandatory-tags")<br>    deploy_assignment      = optional(bool, true)<br>    management_group_id    = optional(string)<br>    enforce                = optional(bool, true)<br>    non_compliance_message = optional(string)<br>    description            = optional(string)<br>    effect                 = optional(string, "Audit")<br>    required_tags = list(object({<br>      key     = string<br>      pattern = string<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_non_privileged_role_restriction_policy"></a> [non\_privileged\_role\_restriction\_policy](#input\_non\_privileged\_role\_restriction\_policy) | Configuration for the non privileged role restriction policy, this policy allows you to restrict specific role definition IDs to specific principal types, in the event you would like users to have different access to other things like Managed Identities (normally used in automation) | <pre>object({<br>    name                                                      = optional(string, "restrict-roles-for-non-privileged")<br>    management_group_id                                       = optional(string)<br>    deploy_assignment                                         = optional(bool, true)<br>    enforce                                                   = optional(bool, true)<br>    non_compliance_message                                    = optional(string)<br>    description                                               = optional(string)<br>    effect                                                    = optional(string, "Audit")<br>    non_privileged_role_definition_ids                        = optional(list(string), [])<br>    non_privileged_role_definition_restricted_principal_types = optional(list(string), ["User", "Group"])<br>  })</pre> | n/a | yes |
| <a name="input_policy_error_prefix"></a> [policy\_error\_prefix](#input\_policy\_error\_prefix) | The prefix to apply to custom policies | `string` | `"[PlatformPolicyException]:"` | no |
| <a name="input_policy_prefix"></a> [policy\_prefix](#input\_policy\_prefix) | The prefix to apply to the custom policies | `string` | `"[LibreDevOps Custom]"` | no |
| <a name="input_privileged_role_restriction_policy"></a> [privileged\_role\_restriction\_policy](#input\_privileged\_role\_restriction\_policy) | Configuration for the role restriction policy, this policy allows you to restrict specific role definition IDs to specific principal types, in the event you would like users to have different access to other things like Managed Identities (normally used in automation) | <pre>object({<br>    name                           = optional(string, "restrict-roles-for-principal-type")<br>    management_group_id            = optional(string)<br>    deploy_assignment              = optional(bool, true)<br>    enforce                        = optional(bool, true)<br>    non_compliance_message         = optional(string)<br>    description                    = optional(string)<br>    effect                         = optional(string, "Audit")<br>    privileged_role_definition_ids = optional(list(string), [])<br>    privileged_role_definition_restricted_principal_types = optional(list(string), [<br>      "ServicePrincipal", "ManagedIdentity", "Application"<br>    ])<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
