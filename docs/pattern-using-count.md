# Terraform Pattern: Using count and count.index with an Azure Policy Definition resource

## Problem Statement
* We need to deploy a policy definition multiple times based on the count of tag keys from a variable list.
* We need to reference the values from the variable list for each policy definition.

## Steps

1. Define a variable list
2. Deploy a resource multiple times based on the length of the variable list
3. Reference all values from the variable list using [count.index]

### 1 - Define a variable list

Create a variable list for tag keys and provide default values if desired.

```hcl
variable "mandatory_tag_keys" {
  type        = list
  description = "List of mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG','bulkAddTagsToRG','bulkInheritTagsFromRG'"
  default = [
    "Application",
    "CostCentre",
    "Environment",
    "ManagedBy",
    "OwnedBy",
    "SupportBy"
  ]
}
```

### 2 - Deploy a resource multiple times based on the length of the variable list

Within the resource block reference the variable list using `count = length(var.variableName)`.

Because we have 6 tag keys listed in the `mandatory_tag_keys` variable above, the resource below will be deployed 6 times.

```hcl
resource "azurerm_policy_definition" "addTagToRG" {
  count = length(var.mandatory_tag_keys)
```

### 3 - Reference all values from the variable list using [count.index]

Within the resource block reference the variable list values index using `${var.variableName[count.index]}`.

Using [count.index] means each value contained in the variable list above will be referenced by each resource deployment in this resource block.

Specific index items can also be referenced using `${var.variableName[0]}`,`${var.variableName[1]}`,`${var.variableName[2]}`, etc.

```hcl
  name         = "addTagToRG_${var.mandatory_tag_keys[count.index]}"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Add tag ${var.mandatory_tag_keys[count.index]} to resource group"
  description  = "Adds the mandatory tag key ${var.mandatory_tag_keys[count.index]} when any resource group missing this tag is created or updated. \nExisting resource groups can be remediated by triggering a remediation task.\nIf the tag exists with a different value it will not be changed."
  metadata = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule = <<POLICY_RULE
    {
        "if": {
          "allOf": [
            {
              "field": "type",
              "equals": "Microsoft.Resources/subscriptions/resourceGroups"
            },
            {
              "field": "[concat('tags[', parameters('tagName'), ']')]",
              "exists": "false"
            }
          ]
        },
        "then": {
          "effect": "modify",
          "details": {
            "roleDefinitionIds": [
              "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "operations": [
              {
                "operation": "add",
                "field": "[concat('tags[', parameters('tagName'), ']')]",
                "value": "[parameters('tagValue')]"
              }
            ]
          }
        }
  }
POLICY_RULE
  parameters = <<PARAMETERS
    {
        "tagName": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[count.index]}",
            "description": "Name of the tag, such as ${var.mandatory_tag_keys[count.index]}"
          },
          "defaultValue": "${var.mandatory_tag_keys[count.index]}"
        },
        "tagValue": {
          "type": "String",
          "metadata": {
            "displayName": "Tag Value '${var.mandatory_tag_value}'",
            "description": "Value of the tag, such as '${var.mandatory_tag_value}'"
          },
          "defaultValue": "'${var.mandatory_tag_value}'"
        }
  }
PARAMETERS
}
```

### Home
[terraform-azurerm-policy](https://globalbao.github.io/terraform-azurerm-policy/)
