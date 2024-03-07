locals {
  approved_resources_policy_approved_services_actions_name_prefix = data.azurerm_policy_definition_built_in.allowed_resource_types.display_name
  approved_resources_policy_approved_services_actions_name_hash   = substr(md5(local.approved_resources_policy_approved_services_actions_name_prefix), 0, 12)
  approved_resources_policy_approved_services_actions_name_convert = join(" ", [
    for string in split("-", data.azurerm_policy_definition_built_in.allowed_resource_types.display_name) : title(string)
  ])
  approved_resources_policy_approved_services_actions_display_name            = format("%s - %s", var.policy_prefix, local.approved_resources_policy_approved_services_actions_name_convert)
  approved_resources_policy_approved_services_actions_policy_purpose          = "This Policy provides a list of approved services actions that can be deployed in the scope"
  approved_resources_policy_approved_services_actions_recommended_remediation = "The resource that you've tried to deploy is not in the allowed services actions"
  approved_resources_policy_approved_services_actions_non_compliance_message  = "${var.policy_error_prefix} You have attempted to perform a restricted action via the ${local.approved_resources_policy_approved_services_actions_display_name} policy. ${local.approved_resources_policy_approved_services_actions_recommended_remediation}.  Please contact the administrators for further assistance."
  approved_resources_policy_services_actions                                  = []
  approved_resources_policy_approved_services_actions                         = distinct(concat(var.allowed_resources_policy.approved_resources, local.approved_resources_policy_services_actions))
}


data "azurerm_policy_definition_built_in" "allowed_resource_types" {
  display_name = "Allowed resource types"
}

resource "azurerm_management_group_policy_assignment" "approved_services_actions_assignment" {
  name                 = local.approved_resources_policy_approved_services_actions_name_hash
  policy_definition_id = data.azurerm_policy_definition_built_in.allowed_resource_types.id
  management_group_id  = var.allowed_resources_policy.management_group_id != null ? var.allowed_resources_policy.management_group_id : (var.attempt_read_tenant_root_group ? data.azurerm_management_group.tenant_root_group[0].id : null)
  enforce              = true
  display_name         = local.approved_resources_policy_approved_services_actions_display_name
  description          = local.approved_resources_policy_approved_services_actions_policy_purpose

  non_compliance_message {
    content = local.approved_resources_policy_approved_services_actions_non_compliance_message
  }

  parameters = jsonencode({
    "listOfResourceTypesAllowed" = {
      "value" = local.approved_resources_policy_approved_services_actions
    }
  })
}

locals {
  approved_resource_providers_name_prefix = var.allowed_resources_policy.name
  approved_resource_providers_name_hash   = substr(md5(local.approved_resource_providers_name_prefix), 0, 12)
  approved_resource_providers_name_convert = join(" ", [
    for string in split("-", var.allowed_resources_policy.name) : title(string)
  ])
  approved_resource_providers_display_name            = format("%s - %s", var.policy_prefix, local.approved_resource_providers_name_convert)
  approved_resources_policy_purpose                   = "This Policy provides a list of allowed resource providers, e.g Microsoft.KeyVault that can be deployed in the scope"
  approved_resource_providers_recommended_remediation = "You should ensure attempting to deploy an approved resource"
  approved_resource_providers_non_compliance_message  = "${var.policy_error_prefix} You have attempted to perform a restricted action via the ${local.approved_resource_providers_display_name} policy. ${local.approved_resource_providers_recommended_remediation}.  Please contact the administrators for further assistance."
}


resource "azurerm_policy_definition" "approved_resources_policy" {
  name                = local.approved_resource_providers_name_hash
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = local.approved_resource_providers_display_name
  description         = var.allowed_resources_policy.description != null ? var.allowed_resources_policy.description : local.approved_resources_policy_purpose
  management_group_id = var.allowed_resources_policy.management_group_id != null ? var.allowed_resources_policy.management_group_id : (var.attempt_read_tenant_root_group ? data.azurerm_management_group.tenant_root_group[0].id : null)

  metadata = jsonencode({
    version  = "1.0.0",
    category = "Security"
    author   = var.policy_prefix
  })

  policy_rule = jsonencode({
    "if" = {
      "not" = {
        "value" = "[first(split(field('type'), '/'))]",
        "in"    = "[parameters('approvedResourceProviders')]"
      }
    },
    "then" = {
      "effect" = "[parameters('effect')]"
    }
  })

  parameters = jsonencode({
    "approvedResourceProviders" : {
      "type" : "Array",
      "metadata" : {
        "description" : "The list of resource providers which can be deployed.",
        "displayName" : "Allowed Resource providers"
      }
    },
    "effect" = {
      "type" = "String",
      "metadata" = {
        "displayName" = "Effect",
        "description" = "Deny, Audit or Disable the execution of the Policy"
      },
      "allowedValues" = [
        "Deny",
        "Audit",
        "Disabled"
      ],
      "defaultValue" = "Deny"
    }
  })
}

locals {
  lowercase_approved_services_list = [for item in var.allowed_resources_policy.approved_resources : lower(item)]
  approved_services                = distinct(toset(sort(local.lowercase_approved_services_list)))

  # Split each item in the list by "/", and then take the first element (provider part)
  approved_services_parts = [
    for service in local.approved_services : split("/", service)[0]
  ]

  # Use distinct to ensure we only have unique provider names
  default_approved_resource_providers = distinct(toset(sort(local.approved_services_parts)))

  approved_resource_providers = distinct(concat(local.default_approved_resource_providers, var.allowed_resources_policy.additional_resource_providers))
}

resource "azurerm_management_group_policy_assignment" "approved_resource_providers_assignment" {
  count                = var.allowed_resources_policy.deploy_assignment ? 1 : 0
  name                 = azurerm_policy_definition.approved_resources_policy.name
  policy_definition_id = azurerm_policy_definition.approved_resources_policy.id
  management_group_id  = var.allowed_resources_policy.management_group_id != null ? var.allowed_resources_policy.management_group_id : (var.attempt_read_tenant_root_group ? data.azurerm_management_group.tenant_root_group[0].id : null)
  enforce              = var.allowed_resources_policy.enforce != null ? var.allowed_resources_policy.enforce : true
  display_name         = local.approved_resource_providers_display_name
  description          = var.allowed_resources_policy.description != null ? var.allowed_resources_policy.description : local.approved_resources_policy_purpose

  non_compliance_message {
    content = var.allowed_resources_policy.non_compliance_message != null ? var.allowed_resources_policy.non_compliance_message : local.approved_resource_providers_non_compliance_message
  }

  parameters = jsonencode({
    "approvedResourceProviders" = {
      "value" = local.approved_resource_providers
    },
    "effect" = {
      "value" = var.allowed_resources_policy.effect
    }
  })
}
