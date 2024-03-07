```hcl
module "dev" {
  source = "../../"

  non_privileged_role_restriction_policy = {
    deploy_assignment = true
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
    deploy_assignment = true
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
    deploy_assignment = true
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
    deploy_assignment = true
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
    deploy_assignment = true
    effect            = "Append"
  }

  deny_nsg_deletion_action_policy = {
    deploy_assignment = true
  }

  add_resource_lock_to_nsg_policy = {
    deploy_assignment       = true
    attempt_role_assignment = true
  }

  allowed_resources_policy = {
    deploy_assignment = true
  }
}
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.91.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dev"></a> [dev](#module\_dev) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_string.entropy](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_client_config.current_creds](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.mgmt_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_resource_group.mgmt_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_ssh_public_key.mgmt_ssh_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/ssh_public_key) | data source |
| [azurerm_user_assigned_identity.mgmt_user_assigned_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Regions"></a> [Regions](#input\_Regions) | Converts shorthand name to longhand name via lookup on map list | `map(string)` | <pre>{<br>  "eus": "East US",<br>  "euw": "West Europe",<br>  "uks": "UK South",<br>  "ukw": "UK West"<br>}</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | This is passed as an environment variable, it is for the shorthand environment tag for resource.  For example, production = prod | `string` | `"prd"` | no |
| <a name="input_loc"></a> [loc](#input\_loc) | The shorthand name of the Azure location, for example, for UK South, use uks.  For UK West, use ukw. Normally passed as TF\_VAR in pipeline | `string` | `"uks"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of this resource | `string` | `"tst"` | no |
| <a name="input_short"></a> [short](#input\_short) | This is passed as an environment variable, it is for a shorthand name for the environment, for example hello-world = hw | `string` | `"lbd"` | no |

## Outputs

No outputs.
