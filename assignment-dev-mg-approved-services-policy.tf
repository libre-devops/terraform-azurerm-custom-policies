locals {

  default_development_management_group_approved_resource_types = [
    "Microsoft.AlertsManagement/SmartDetectorAlertRules",
    "Microsoft.Automation/AutomationAccounts",
    "Microsoft.Compute/disks",
    "Microsoft.Compute/galleries",
    "Microsoft.Compute/galleries/images",
    "Microsoft.Compute/galleries/versions",
    "Microsoft.Compute/galleries/applications",
    "Microsoft.Compute/galleries/versions",
    "Microsoft.Compute/galleries/servicesArtifacts",
    "Microsoft.Compute/images",
    "Microsoft.Compute/sshPublicKeys",
    "Microsoft.Compute/virtualMachines",
    "Microsoft.Compute/virtualMachines/extensions",
    "Microsoft.Insights/ActionGroups",
    "Microsoft.Insights/Components",
    "Microsoft.Insights/Workbooks",
    "Microsoft.Insights/datacollectionrules",
    "microsoft.insights/datacollectionendpoints",
    "Microsoft.KeyVault/vaults",
    "Microsoft.Logic/Workflows",
    "Microsoft.ManagedIdentity/UserAssignedIdentities",
    "Microsoft.ManagedIdentity/userAssignedIdentities",
    "Microsoft.Network/NetworkSecurityGroups",
    "Microsoft.Network/NetworkWatchers",
    "Microsoft.Network/PrivateDnsZones",
    "Microsoft.Network/PrivateDnsZones/VirtualNetworkLinks",
    "Microsoft.Network/VirtualNetworks",
    "Microsoft.Network/applicationSecurityGroups",
    "Microsoft.Network/bastionHosts",
    "Microsoft.Network/connections",
    "Microsoft.Network/networkInterfaces",
    "Microsoft.Network/networkSecurityGroups",
    "Microsoft.Network/networkWatchers",
    "Microsoft.Network/privateDnsZones",
    "Microsoft.Network/privateDnsZones/virtualNetworkLinks",
    "Microsoft.Network/publicIPAddresses",
    "Microsoft.Security/Automations",
    "Microsoft.Security/automations",
    "Microsoft.Storage/StorageAccounts",
    "Microsoft.Storage/storageAccounts",
    "Microsoft.Web/Connections",
    "Microsoft.Web/ServerFarms",
    "Microsoft.Web/Sites",
    "microsoft.authorization/locks",
    "microsoft.keyvault/vaults",
    "microsoft.network/networksecuritygroups",
    "microsoft.network/networkwatchers",
    "microsoft.network/privatednszones",
    "microsoft.network/privatednszones/virtualnetworklinks",
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
    "microsoft.operationsmanagement/solutions"
  ]

  # Split each item in the list by "/", and then take the first element (provider part)
  development_management_group_actions_parts = [
    for service in local.default_development_management_group_approved_resource_types : split("/", service)[0]
  ]

  # Use distinct to ensure we only have unique provider names
  default_development_management_group_approved_resource_providers = distinct(toset(local.development_management_group_actions_parts))

  development_management_group_approved_resource_providers_display_name = format("%s - %s - %s", var.policy_prefix, local.approved_resource_providers_name_convert, data.azurerm_management_group.development_mg.display_name)
  development_management_group_resource_providers = [
    "Microsoft.Advisor"
  ]
  development_management_group_approved_resource_providers = distinct(concat(local.default_development_management_group_approved_resource_providers, local.development_management_group_resource_providers))
}

resource "azurerm_management_group_policy_assignment" "development_management_group_approved_resource_providers_assignment" {
  count                = var.approved_resource_providers_policy.deploy_assignment ? 1 : 0
  name                 = azurerm_policy_definition.approved_resource_providers_policy.name
  policy_definition_id = azurerm_policy_definition.approved_resource_providers_policy.id
  management_group_id  = data.azurerm_management_group.development_mg.id
  enforce              = var.approved_resource_providers_policy.enforce != null ? var.approved_resource_providers_policy.enforce : true
  display_name         = local.development_management_group_approved_resource_providers_display_name
  description          = var.approved_resource_providers_policy.description != null ? var.approved_resource_providers_policy.description : local.approved_resource_providers_policy_purpose

  non_compliance_message {
    content = var.approved_resource_providers_policy.non_compliance_message != null ? var.approved_resource_providers_policy.non_compliance_message : local.approved_resource_providers_non_compliance_message
  }

  parameters = jsonencode({
    "approvedResourceProviders" = {
      "value" = local.development_management_group_approved_resource_providers
    },
    "effect" = {
      "value" = var.approved_resource_providers_policy.effect
    }
  })
}

locals {
  development_management_group_approved_resource_types_name_prefix = data.azurerm_policy_definition_built_in.allowed_resource_types.display_name
  development_management_group_approved_resource_types_name_hash   = substr(md5(local.development_management_group_approved_resource_types_name_prefix), 0, 12)
  development_management_group_approved_resource_types_name_convert = join(" ", [
    for string in split("-", data.azurerm_policy_definition_built_in.allowed_resource_types.display_name) : title(string)
  ])
  development_management_group_approved_resource_types_display_name            = format("%s - %s - %s", var.policy_prefix, local.development_management_group_approved_resource_types_name_convert, data.azurerm_management_group.development_mg.display_name)
  development_management_group_approved_resource_types_policy_purpose          = "This Policy provides a list of approved services actions that can be deployed in the scope"
  development_management_group_approved_resource_types_recommended_remediation = "The resource that you've tried to deploy is not in the allowed services actions"
  development_management_group_approved_resource_types_non_compliance_message  = "${var.policy_error_message_prefix} You have attempted to perform a restricted action via the ${local.development_management_group_approved_resource_types_display_name} policy. ${local.development_management_group_approved_resource_types_recommended_remediation}.  Please contact the administrators: ${var.admin_email} for further assistance."
  development_management_group_services_actions                                  = []
  development_management_group_approved_resource_types                         = distinct(concat(local.default_development_management_group_approved_resource_types, local.development_management_group_services_actions))
}

resource "azurerm_management_group_policy_assignment" "development_management_group_approved_resource_types_assignment" {
  name                 = local.development_management_group_approved_resource_types_name_hash
  policy_definition_id = data.azurerm_policy_definition_built_in.allowed_resource_types.id
  management_group_id  = data.azurerm_management_group.development_mg.id
  enforce              = true
  display_name         = local.development_management_group_approved_resource_types_display_name
  description          = local.development_management_group_approved_resource_types_policy_purpose

  non_compliance_message {
    content = local.development_management_group_approved_resource_types_non_compliance_message
  }

  parameters = jsonencode({
    "listOfResourceTypesAllowed" = {
      "value" = local.development_management_group_approved_resource_types
    }
  })
}
