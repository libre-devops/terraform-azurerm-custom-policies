#locals {
#  deploy_azure_activity_diagnostics_to_subscriptions_name_prefix = var.deploy_azure_activity_diagnostics_to_subscriptions_policy.name
#  deploy_azure_activity_diagnostics_to_subscriptions_name_hash   = substr(md5(local.deploy_azure_activity_diagnostics_to_subscriptions_name_prefix), 0, 12)
#  privileged_principal_types_as_string                           = join(", ", [
#    for s in var.deploy_azure_activity_diagnostics_to_subscriptions_policy.privileged_role_definition_restricted_principal_types :
#    format("%q", s)
#  ])
#}
#
#resource "azurerm_policy_definition" "deploy_azure_activity_diagnostics_to_subscriptions_policy" {
#  name                = local.deploy_azure_activity_diagnostics_to_subscriptions_name_hash
#  policy_type         = "Custom"
#  mode                = "Incremental"
#  display_name        = "${var.policy_prefix} - Deploy Diagnostics for Azure Activity"
#  description         = var.deploy_azure_activity_diagnostics_to_subscriptions_policy.description != null ? var.deploy_azure_activity_diagnostics_to_subscriptions_policy.description : "This policy allows specific roles for specific principalTypes, which allows the administrator to allow greater access for, for example, Managed Identities used in automation, but deny similar access to users"
#  management_group_id = var.deploy_azure_activity_diagnostics_to_subscriptions_policy.management_group_id != null ? var.deploy_azure_activity_diagnostics_to_subscriptions_policy.management_group_id : (var.attempt_read_tenant_root_group ? data.azurerm_management_group.tenant_root_group[0].id : null)
#
#  metadata = jsonencode({
#    version  = "1.0.0",
#    category = "Auditing and Logging"
#    author   = var.policy_prefix
#  })
#
#  policy_rule = jsonencode({
#    "if" : {
#      "field" : "type",
#      "equals" : "Microsoft.Resources/subscriptions"
#    },
#    "then" : {
#      "effect" : "[parameters('effect')]",
#      "details" : {
#        "type" : "microsoft.insights/diagnosticSettings",
#        "existenceCondition" : {
#          "allOf" : [
#            {
#              "field" : "Microsoft.Insights/diagnosticSettings/workspaceId",
#              "equals" : "[parameters('workspaceId')]"
#            },
#            {
#              "field" : "Microsoft.Insights/diagnosticSettings/storageAccountId",
#              "equals" : "[parameters('storageAccountId')]"
#            }
#          ]
#        },
#        "roleDefinitionIds" : [
#          "/providers/microsoft.authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa",
#          "/providers/microsoft.authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293"
#        ],
#        "deployment" : {
#          "properties" : {
#            "mode" : "incremental",
#            "template" : {
#              "$schema" : "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
#              "contentVersion" : "1.0.0.0",
#              "parameters" : {
#                "profileName" : {
#                  "type" : "string"
#                },
#                "workspaceId" : {
#                  "type" : "string"
#                },
#                "storageAccountId" : {
#                  "type" : "string"
#                }
#              },
#              "variables" : {},
#              "resources" : [
#                {
#                  "type" : "microsoft.insights/diagnosticSettings",
#                  "apiVersion" : "2017-05-01-preview",
#                  "name" : "[parameters('profileName')]",
#                  "properties" : {
#                    "workspaceId" : "[parameters('workspaceId')]",
#                    "storageAccountId" : "[parameters('storageAccountId')]",
#                    "logs" : [
#                      {
#                        "category" : "Administrative",
#                        "enabled" : true
#                      },
#                      {
#                        "category" : "Security",
#                        "enabled" : true
#                      },
#                      {
#                        "category" : "ServiceHealth",
#                        "enabled" : true
#                      },
#                      {
#                        "category" : "Alert",
#                        "enabled" : true
#                      },
#                      {
#                        "category" : "Recommendation",
#                        "enabled" : true
#                      },
#                      {
#                        "category" : "Policy",
#                        "enabled" : true
#                      },
#                      {
#                        "category" : "Autoscale",
#                        "enabled" : true
#                      },
#                      {
#                        "category" : "ResourceHealth",
#                        "enabled" : true
#                      }
#                    ]
#                  }
#                }
#              ],
#              "outputs" : {}
#            },
#            "parameters" : {
#              "workspaceId" : {
#                "value" : "[parameters('workspaceId')]"
#              },
#              "profileName" : {
#                "value" : "[parameters('profileName')]"
#              },
#              "storageAccountId" : {
#                "value" : "[parameters('storageAccountId')]"
#              }
#            }
#          },
#          "location" : "eastus"
#        },
#        "deploymentScope" : "subscription"
#      }
#    }
#  })
#
#  parameters = jsonencode({
#    "profileName" : {
#      "type" : "string"
#    },
#    "workspaceId" : {
#      "type" : "string"
#    },
#    "storageAccountId" : {
#      "type" : "string"
#    }
#  })
#}
#
#locals {
#  extra_privileged_role_definition_ids = []
#  privileged_role_definition_ids       = distinct(concat(var.deploy_azure_activity_diagnostics_to_subscriptions_policy.privileged_role_definition_ids, local.extra_privileged_role_definition_ids))
#}
#
#resource "azurerm_management_group_policy_assignment" "deploy_azure_activity_diagnostics_to_subscriptions_assignment" {
#  count                = var.deploy_azure_activity_diagnostics_to_subscriptions_policy.deploy_assignment ? 1 : 0
#  name                 = azurerm_policy_definition.deploy_azure_activity_diagnostics_to_subscriptions_policy.name
#  management_group_id  = var.deploy_azure_activity_diagnostics_to_subscriptions_policy.management_group_id != null ? var.deploy_azure_activity_diagnostics_to_subscriptions_policy.management_group_id : (var.attempt_read_tenant_root_group ? data.azurerm_management_group.tenant_root_group[0].id : null)
#  policy_definition_id = azurerm_policy_definition.deploy_azure_activity_diagnostics_to_subscriptions_policy.id
#  enforce              = var.deploy_azure_activity_diagnostics_to_subscriptions_policy.enforce != null ? var.deploy_azure_activity_diagnostics_to_subscriptions_policy.enforce : true
#  display_name         = azurerm_policy_definition.deploy_azure_activity_diagnostics_to_subscriptions_policy.display_name
#  description          = var.deploy_azure_activity_diagnostics_to_subscriptions_policy.description != null ? var.deploy_azure_activity_diagnostics_to_subscriptions_policy.description : "This policy allows specific roles for ${local.privileged_principal_types_as_string}."
#
#  non_compliance_message {
#    content = var.deploy_azure_activity_diagnostics_to_subscriptions_policy.non_compliance_message != null ? var.deploy_azure_activity_diagnostics_to_subscriptions_policy.non_compliance_message : "${var.policy_error_prefix} The role you have tried to deploy has been restricted by ${azurerm_policy_definition.deploy_azure_activity_diagnostics_to_subscriptions_policy.display_name} policy. This role only allows specific roles for ${local.privileged_principal_types_as_string} Please contact your administrator for assistance."
#  }
#
#  parameters = jsonencode({
#    "privilegedAllowedPrincipalTypes" = {
#      "value" = var.deploy_azure_activity_diagnostics_to_subscriptions_policy.privileged_role_definition_restricted_principal_types
#    },
#    "privilegedRoleDefinitionIds" = {
#      "value" = local.privileged_role_definition_ids
#    },
#    "effect" = {
#      "value" = var.deploy_azure_activity_diagnostics_to_subscriptions_policy.effect
#    }
#  })
#}
