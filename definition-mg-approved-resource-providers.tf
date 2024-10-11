locals {
  approved_resource_providers_name_prefix = var.approved_resource_providers_policy.name
  approved_resource_providers_name_hash   = substr(md5(local.approved_resource_providers_name_prefix), 0, 12)
  approved_resource_providers_name_convert = join(" ", [
    for string in split("-", var.approved_resource_providers_policy.name) : title(string)
  ])
  approved_resource_providers_display_name            = format("%s - %s", var.policy_prefix, local.approved_resource_providers_name_convert)
  approved_resource_providers_policy_purpose          = "This Policy provides a list of approved resource providers that can be deployed in the scope"
  approved_resource_providers_recommended_remediation = "You should ensure attempting to deploy an approved resource"
  approved_resource_providers_non_compliance_message  = "${var.policy_error_message_prefix} You have attempted to perform a restricted action via the ${local.approved_resource_providers_display_name} policy. ${local.approved_resource_providers_recommended_remediation}.  Please contact the administrators for further assistance."
}

resource "azurerm_policy_definition" "approved_resource_providers_policy" {
  name                = local.approved_resource_providers_name_hash
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = local.approved_resource_providers_display_name
  description         = var.approved_resource_providers_policy.description != null ? var.approved_resource_providers_policy.description : local.approved_resource_providers_policy_purpose
  management_group_id = var.approved_resource_providers_policy.management_group_id != null ? var.approved_resource_providers_policy.management_group_id : (var.attempt_data_lookup_tenant_root_group ? data.azurerm_management_group.tenant_root_group[0].id : null)

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
        "displayName" : "Approved resource providers"
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
      "defaultValue" = "Audit"
    }
  })
}