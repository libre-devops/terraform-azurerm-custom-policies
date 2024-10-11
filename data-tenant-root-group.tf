data "azurerm_management_group" "tenant_root_group" {
  count        = var.attempt_data_lookup_tenant_root_group == true ? 1 : 0
  display_name = "Tenant Root Group"
}