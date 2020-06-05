resource "azurerm_policy_definition" "addTagToRG" {
  count = length(var.mandatory_tag_keys)

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

resource "azurerm_policy_definition" "inheritTagFromRG" {
  count = length(var.mandatory_tag_keys)

  name         = "inheritTagFromRG_${var.mandatory_tag_keys[count.index]}"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Inherit tag ${var.mandatory_tag_keys[count.index]} from the resource group"
  description  = "Adds the specified mandatory tag ${var.mandatory_tag_keys[count.index]} with its value from the parent resource group when any resource missing this tag is created or updated. Existing resources can be remediated by triggering a remediation task. If the tag exists with a different value it will not be changed."

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
              "field": "[concat('tags[', parameters('tagName'), ']')]",
              "exists": "false"
            },
            {
              "value": "[resourceGroup().tags[parameters('tagName')]]",
              "notEquals": ""
            }
          ]
        },
        "then": {
          "effect": "modify",
          "details": {
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "operations": [
              {
                "operation": "add",
                "field": "[concat('tags[', parameters('tagName'), ']')]",
                "value": "[resourceGroup().tags[parameters('tagName')]]"
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
            "description": "Name of the tag, such as '${var.mandatory_tag_keys[count.index]}'"
          },
          "defaultValue": "${var.mandatory_tag_keys[count.index]}"
        }
  }
PARAMETERS

}

resource "azurerm_policy_definition" "bulkAddTagsToRG" {
  name         = "bulkAddTagsToRG"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Bulk add tags to a resource group"
  description  = "Bulk adds the mandatory tags and tag value when any resource group missing the tags are created or updated. Existing resource groups can be remediated by triggering a remediation task.If the tag exists with a different value it will not be changed."

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
          "allOf": [
            {
              "field": "[concat('tags[', parameters('tagName1'), ']')]",
              "exists": "false"
            },
            {
              "field": "[concat('tags[', parameters('tagName3'), ']')]",
              "exists": "false"
            },
            {
              "field": "[concat('tags[', parameters('tagName4'), ']')]",
              "exists": "false"
            },
            {
              "field": "[concat('tags[', parameters('tagName5'), ']')]",
              "exists": "false"
            },
            {
              "field": "[concat('tags[', parameters('tagName6'), ']')]",
              "exists": "false"
            }
          ]
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
            "field": "[concat('tags[', parameters('tagName1'), ']')]",
            "value": "[parameters('tagValue')]"
          },
          {
            "operation": "add",
            "field": "[concat('tags[', parameters('tagName2'), ']')]",
            "value": "[parameters('tagValue')]"
          },
          {
            "operation": "add",
            "field": "[concat('tags[', parameters('tagName3'), ']')]",
            "value": "[parameters('tagValue')]"
          },
          {
            "operation": "add",
            "field": "[concat('tags[', parameters('tagName4'), ']')]",
            "value": "[parameters('tagValue')]"
          },
          {
            "operation": "add",
            "field": "[concat('tags[', parameters('tagName5'), ']')]",
            "value": "[parameters('tagValue')]"
          },
          {
            "operation": "add",
            "field": "[concat('tags[', parameters('tagName6'), ']')]",
            "value": "[parameters('tagValue')]"
          }
        ]
      }
    }
  }
POLICY_RULE


  parameters = <<PARAMETERS
    {
        "tagName1": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[0]}",
            "description": "Name of the tag, such as '${var.mandatory_tag_keys[0]}'"
          },
          "defaultValue": "${var.mandatory_tag_keys[0]}"
        },
        "tagName2": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[1]}",
            "description": "Name of the tag, such as '${var.mandatory_tag_keys[1]}'"
          },
          "defaultValue": "${var.mandatory_tag_keys[1]}"
        },
        "tagName3": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[2]}",
            "description": "Name of the tag, such as '${var.mandatory_tag_keys[2]}'"
          },
          "defaultValue": "${var.mandatory_tag_keys[2]}"
        },
        "tagName4": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[3]}",
            "description": "Name of the tag, such as '${var.mandatory_tag_keys[3]}'"
          },
          "defaultValue": "${var.mandatory_tag_keys[3]}"
        },
        "tagName5": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[4]}",
            "description": "Name of the tag, such as '${var.mandatory_tag_keys[4]}'"
          },
          "defaultValue": "${var.mandatory_tag_keys[4]}"
        },
        "tagName6": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[5]}",
            "description": "Name of the tag, such as '${var.mandatory_tag_keys[5]}'"
          },
          "defaultValue": "${var.mandatory_tag_keys[5]}"
        },
        "tagValue": {
          "type": "String",
          "metadata": {
            "displayName": "Tag Value ${var.mandatory_tag_value}",
            "description": "Value of the tag, such as '${var.mandatory_tag_value}'"
          },
          "defaultValue": "${var.mandatory_tag_value}"
        }
  }
PARAMETERS

}

resource "azurerm_policy_definition" "bulkInheritTagsFromRG" {
  name         = "bulkInheritTagsFromRG"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Bulk inherit tags from the resource group"
  description  = "Bulk adds the specified mandatory tags with its value from the parent resource group when any resource missing this tag is created or updated. Existing resources can be remediated by triggering a remediation task. If the tag exists with a different value it will not be changed."

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
              "field": "[concat('tags[', parameters('tagName1'), ']')]",
              "exists": "false"
            },
            {
              "field": "[concat('tags[', parameters('tagName2'), ']')]",
              "exists": "false"
            },
            {
              "field": "[concat('tags[', parameters('tagName3'), ']')]",
              "exists": "false"
            },
            {
              "field": "[concat('tags[', parameters('tagName4'), ']')]",
              "exists": "false"
            },
            {
              "field": "[concat('tags[', parameters('tagName5'), ']')]",
              "exists": "false"
            },
            {
              "field": "[concat('tags[', parameters('tagName6'), ']')]",
              "exists": "false"
            },
            {
              "value": "[resourceGroup().tags[parameters('tagName1')]]",
              "notEquals": ""
            },
            {
              "value": "[resourceGroup().tags[parameters('tagName2')]]",
              "notEquals": ""
            },
            {
              "value": "[resourceGroup().tags[parameters('tagName3')]]",
              "notEquals": ""
            }
            ,            {
              "value": "[resourceGroup().tags[parameters('tagName4')]]",
              "notEquals": ""
            }
            ,            {
              "value": "[resourceGroup().tags[parameters('tagName5')]]",
              "notEquals": ""
            }
            ,            {
              "value": "[resourceGroup().tags[parameters('tagName6')]]",
              "notEquals": ""
            }
          ]
        },
        "then": {
          "effect": "modify",
          "details": {
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "operations": [
              {
                "operation": "add",
                "field": "[concat('tags[', parameters('tagName1'), ']')]",
                "value": "[resourceGroup().tags[parameters('tagName1')]]"
              },
              {
                "operation": "add",
                "field": "[concat('tags[', parameters('tagName2'), ']')]",
                "value": "[resourceGroup().tags[parameters('tagName2')]]"
              },
              {
                "operation": "add",
                "field": "[concat('tags[', parameters('tagName3'), ']')]",
                "value": "[resourceGroup().tags[parameters('tagName3')]]"
              },
              {
                "operation": "add",
                "field": "[concat('tags[', parameters('tagName4'), ']')]",
                "value": "[resourceGroup().tags[parameters('tagName4')]]"
              },
              {
                "operation": "add",
                "field": "[concat('tags[', parameters('tagName5'), ']')]",
                "value": "[resourceGroup().tags[parameters('tagName5')]]"
              },
              {
                "operation": "add",
                "field": "[concat('tags[', parameters('tagName6'), ']')]",
                "value": "[resourceGroup().tags[parameters('tagName6')]]"
              }
            ]
          }
        }
  }
POLICY_RULE


  parameters = <<PARAMETERS
    {
        "tagName1": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[0]}",
            "description": "Name of the tag, such as '${var.mandatory_tag_keys[0]}'"
          },
          "defaultValue": "${var.mandatory_tag_keys[0]}"
        },
        "tagName2": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[1]}",
            "description": "Name of the tag, such as '${var.mandatory_tag_keys[1]}'"
          },
          "defaultValue": "${var.mandatory_tag_keys[1]}"
        },
        "tagName3": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[2]}",
            "description": "Name of the tag, such as '${var.mandatory_tag_keys[2]}'"
          },
          "defaultValue": "${var.mandatory_tag_keys[2]}"
        },
        "tagName4": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[3]}",
            "description": "Name of the tag, such as '${var.mandatory_tag_keys[3]}'"
          },
          "defaultValue": "${var.mandatory_tag_keys[3]}"
        },
        "tagName5": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[4]}",
            "description": "Name of the tag, such as '${var.mandatory_tag_keys[4]}'"
          },
          "defaultValue": "${var.mandatory_tag_keys[4]}"
        },
        "tagName6": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[5]}",
            "description": "Name of the tag, such as '${var.mandatory_tag_keys[5]}'"
          },
          "defaultValue": "${var.mandatory_tag_keys[5]}"
        }
  }
PARAMETERS

}

resource "azurerm_policy_definition" "auditRoleAssignmentType_user" {
  name         = "auditRoleAssignmentType_user"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit user role assignments"
  description  = "This policy checks for any Role Assignments of Type [User] - useful to catch individual IAM assignments to resources/RGs which are out of compliance with the RBAC standards e.g. using Groups for RBAC."

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
          "equals": "Microsoft.Authorization/roleAssignments"
        },
        {
          "field": "Microsoft.Authorization/roleAssignments/principalType",
          "equals": "[parameters('principalType')]"
        }
      ]
    },
    "then": {
      "effect": "audit"
    }
  }
POLICY_RULE


  parameters = <<PARAMETERS
    {
    "principalType": {
      "type": "String",
      "metadata": {
        "displayName": "principalType",
        "description": "Which principalType to audit against e.g. 'User'"
      },
      "allowedValues": [
        "User",
        "Group",
        "ServicePrincipal"
      ],
      "defaultValue": "User"
    }
  }
PARAMETERS

}

resource "azurerm_policy_definition" "auditLockOnNetworking" {
  name         = "auditLockOnNetworking"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit lock on networking"
  description  = "This policy audits if a resource lock 'CanNotDelete' or 'ReadOnly' has been applied to the specified Networking components."

  metadata = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }

METADATA


  policy_rule = <<POLICY_RULE
    {
    "if": {
          "field": "type",
          "in": "[parameters('resourceTypes')]"
    },
    "then": {
      "effect": "auditIfNotExists",
      "details":{
        "type": "Microsoft.Authorization/locks",
        "existenceCondition": {
          "field": "Microsoft.Authorization/locks/level",
          "in": [
            "ReadOnly",
            "CanNotDelete"
          ]
        }
      }
    }
  }
POLICY_RULE


  parameters = <<PARAMETERS
    {
    "resourceTypes": {
      "type": "Array",
      "metadata":{
        "description": "Azure resource types to audit for Locks",
        "displayName": "resourceTypes"
      },
      "defaultValue": [
        "microsoft.network/expressroutecircuits",
        "microsoft.network/expressroutegateways",
        "microsoft.network/virtualnetworks",
        "microsoft.network/virtualnetworkgateways",
        "microsoft.network/vpngateways",
        "microsoft.network/p2svpngateways"
      ]
    }
  }
PARAMETERS

}