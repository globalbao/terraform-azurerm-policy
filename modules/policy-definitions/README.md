# AzureRM Policy Definitions - Terraform child module
* Vendor reference [https://www.terraform.io/docs/providers/azurerm/r/policy_definition.html](https://www.terraform.io/docs/providers/azurerm/r/policy_definition.html)

## Module files

* `main.tf`
* `outputs.tf`
* `variables.tf`

## Resources (main.tf)

| Resource Type             | Resource name                  | Deployment Count
|:--------------------------|:-------------------------------|:----------------
| azurerm_policy_definition | `addTagToRG`                   | 5
| azurerm_policy_definition | `inheritTagFromRG`             | 5
| azurerm_policy_definition | `bulkAddTagsToRG`              | 1
| azurerm_policy_definition | `bulkInheritTagsFromRG`        | 1
| azurerm_policy_definition | `auditRoleAssignmentType_user` | 1
| azurerm_policy_definition | `auditLockOnNetworking`        | 1

## Input variables (variables.tf)

| Name            | Description | Type | Default Value
|:----------------|:------------|:-----|:---------
| `mandatory_tag_keys`| List of mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG','bulkAddTagsToRG','bulkInheritTagsFromRG' | `list` | "Application", "CostCentre", "Environment", "ManagedBy", "OwnedBy", "SupportBy"
| `mandatory_tag_value` | Tag value to include with the mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG','bulkAddTagsToRG','bulkInheritTagsFromRG' | `string` | "to_be_confirmed"
| `policy_definition_category` | The category to use for all Policy Definitions | `string` | "Custom"

## Output variables (outputs.tf)

| Name | Description | Value
|:-------|:-----------|:----------
| `addTagToRG_policy_ids` | The policy definition ids for addTagToRG policies | ${azurerm_policy_definition.addTagToRG.*.id}
| `inheritTagFromRG_policy_ids` | The policy definition ids for inheritTagFromRG policies | ${azurerm_policy_definition.inheritTagFromRG.*.id}
| `bulkAddTagsToRG_policy_id` | The policy definition ids for inheritTagFromRG policies | ${azurerm_policy_definition.inheritTagFromRG.*.id}
| `bulkInheritTagsFromRG_policy_id` | The policy definition id for bulkInheritTagsFromRG | ${azurerm_policy_definition.bulkInheritTagsFromRG.id}
| `auditRoleAssignmentType_user_policy_id` | The policy definition id for auditRoleAssignmentType_user | ${azurerm_policy_definition.auditRoleAssignmentType_user.id}
| `auditLockOnNetworking_policy_id` | The policy definition id for auditLockOnNetworking | ${azurerm_policy_definition.auditLockOnNetworking.id}
