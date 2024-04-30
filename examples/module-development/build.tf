module "rg" {
  source = "registry.terraform.io/libre-devops/rg/azurerm"

  rg_name  = "rg-${var.short}-${var.loc}-${terraform.workspace}-build" // rg-ldo-euw-dev-build
  location = local.location
  // compares var.loc with the var.regions var to match a long-hand name, in this case, "euw", so "westeurope"
  tags = local.tags

  #  lock_level = "CanNotDelete" // Do not set this value to skip lock
}


module "sa" {
  source = "libre-devops/storage-account/azurerm"
  storage_accounts = [
    {
      name     = "sa${var.short}${var.loc}${var.env}01"
      rg_name  = module.rg.rg_name
      location = module.rg.rg_location
      tags     = module.rg.rg_tags

      identity_type = "SystemAssigned"
      identity_ids  = []

      network_rules = {
        bypass                     = ["AzureServices"]
        default_action             = "Allow"
        ip_rules                   = []
        virtual_network_subnet_ids = []
      }
    }
  ]
}

module "law" {
  source = "registry.terraform.io/libre-devops/log-analytics-workspace/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  create_new_workspace       = true
  law_name                   = "law-${var.short}-${var.loc}-${terraform.workspace}-01"
  law_sku                    = "PerGB2018"
  retention_in_days          = "30"
  daily_quota_gb             = "0.5"
  internet_ingestion_enabled = false
  internet_query_enabled     = false
}

module "dev" {
  source = "../../"

  non_privileged_role_restriction_policy = {
    deploy_assignment = false
    effect            = "Deny"

    non_privileged_role_definition_restricted_principal_types = [
      "User",
      "Group"
    ]
    non_privileged_role_definition_ids = [
      "/providers/Microsoft.Authorization/roleDefinitions/9980e02c-c2be-4d73-94e8-173b1dc7cf3c",
      # Virtual Machine Contributor
    ]
  }

  privileged_role_restriction_policy = {
    deploy_assignment = false
    effect            = "Deny"

    privileged_role_definition_restricted_principal_types = [
      "ServicePrincipal",
      "ManagedIdentity",
      "Application"
    ]
    privileged_role_definition_ids = [
      "/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9",
      # User Access Administrator
    ]
  }

  match_mandatory_resource_tagging_policy = {
    deploy_assignment = false
    effect            = "Deny"

    required_tags = [
      {
        key     = "CostCentre"
        pattern = "#####"
      },
      {
        key     = "ResourceOwner"
        pattern = "*@cyber.scot"
      }
    ]
  }

  like_mandatory_resource_tagging_policy = {
    deploy_assignment = false
    effect            = "Deny"

    required_tags = [
      {
        key     = "CostCentre"
        pattern = "#####"
      },
      {
        key     = "ResourceOwner"
        pattern = "*@cyber.scot"
      }
    ]
  }

  append_default_deny_nsg_rule_policy = {
    deploy_assignment = false
    effect            = "Append"
  }

  deny_nsg_deletion_action_policy = {
    deploy_assignment = false
  }

  add_resource_lock_to_nsg_policy = {
    deploy_assignment       = false
    attempt_role_assignment = false
  }

  allowed_resources_policy = {
    deploy_assignment = false
  }
}
