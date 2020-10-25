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

resource "azurerm_policy_definition" "inheritTagFromRGOverwriteExisting" {
  count = length(var.mandatory_tag_keys)

  name         = "inheritTagFromRG_${var.mandatory_tag_keys[count.index]}_OverwriteExisting"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Inherit tag ${var.mandatory_tag_keys[count.index]} from the resource group & overwrite existing"
  description  = "Overwrites the specified mandatory tag ${var.mandatory_tag_keys[count.index]} and existing value using the RG's tag value. Applicable when any Resource containing the mandatory tag ${var.mandatory_tag_keys[count.index]} is created or updated. Ignores scenarios where tag values are the same for both Resource and RG, or when the RG's tag value is one of the parameters('tagValuesToIgnore'). Existing resources can be remediated by triggering a remediation task."

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
                "exists": "true"
            },
            {
                "value": "[resourceGroup().tags[parameters('tagName')]]",
                "notEquals": ""
            },
            {
                "field": "[concat('tags[', parameters('tagName'), ']')]",
                "notEquals": "[resourceGroup().tags[parameters('tagName')]]"
            },
            {
                "value": "[resourceGroup().tags[parameters('tagName')]]",
                "notIn": "[parameters('tagValuesToIgnore')]"
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
                "operation": "addOrReplace",
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
        },
        "tagValuesToIgnore": {
          "type": "Array",
          "metadata": {
            "displayName": "Tag values to ignore for inheritance",
            "description": "A list of tag values to ignore when evaluating tag inheritance from the RG"
          },
          "defaultValue": [
              "tbc",
              "'tbc'", 
              "TBC", 
              "to_be_confirmed",
              "to be confirmed"
              ]
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

resource "azurerm_policy_definition" "appGateway_CpuUtilization" {
  name         = "appGateway_CpuUtilization"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on appGateway CpuUtilization"
  description  = "Creates an AzMonitor Metric Alert on appGateway for CpuUtilization (Current CPU utilization of the Application Gateway)"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Network/appGateway"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Network/appGateway"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"CpuUtilization"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/appGateway/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Network/appGateway', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-appGateway_CpuUtilization')]",
                            "location": "global",
                            "properties": {
                                "description": "Current CPU utilization of the Application Gateway",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Network/appGateway",
                                            "metricName": "CpuUtilization",
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Network/appGateway",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    }                 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "appGateway_ClientRtt" {
  name         = "appGateway_ClientRtt"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on appGateway ClientRtt"
  description  = "Creates an AzMonitor Metric Alert on appGateway for ClientRtt (Average round trip time between clients and Application Gateway)"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Network/applicationGateways"
        },
        {
          "field": "Microsoft.Network/applicationGateways/sku.tier",
          "equals": "Standard_v2"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Network/applicationGateways"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"ClientRtt"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/applicationGateways/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Network/applicationGateways', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-appGateway_ClientRtt')]",
                            "location": "global",
                            "properties": {
                                "description": "Average round trip time between clients and Application Gateway",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Network/applicationGateways",
                                            "metricName": "ClientRtt",
                                            "dimensions": [
                                                {
                                                    "name": "Listener",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Network/applicationGateways",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "appGateway_UnhealthyHostcount" {
  name         = "appGateway_UnhealthyHostcount"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on appGateway UnhealthyHostcount"
  description  = "Creates an AzMonitor Metric Alert on appGateway for UnhealthyHostcount (Current UnhealthyHostcount of the Application Gateway)"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Network/appGateway"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Network/appGateway"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"UnhealthyHostcount"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/appGateway/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Network/appGateway', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-appGateway_UnhealthyHostcount')]",
                            "location": "global",
                            "properties": {
                                "description": "Current UnhealthyHostcount of the Application Gateway",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Network/appGateway",
                                            "metricName": "UnhealthyHostcount",
                                            "dimensions": [
                                                {
                                                    "name": "BackendSettingsPool",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Network/appGateway",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    }                 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "appGateway_HealthyHostCount" {
  name         = "appGateway_HealthyHostCount"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on appGateway HealthyHostCount"
  description  = "Creates an AzMonitor Metric Alert on appGateway for HealthyHostCount (Current HealthyHostCount of the Application Gateway)"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Network/appGateway"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Network/appGateway"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"HealthyHostCount"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/appGateway/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Network/appGateway', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-appGateway_HealthyHostCount')]",
                            "location": "global",
                            "properties": {
                                "description": "Current HealthyHostCount of the Application Gateway",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Network/appGateway",
                                            "metricName": "HealthyHostCount",
                                            "dimensions": [
                                                {
                                                    "name": "BackendSettingsPool",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Network/appGateway",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    }                 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "appGateway_FailedRequests" {
  name         = "appGateway_FailedRequests"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on appGateway FailedRequests"
  description  = "Creates an AzMonitor Metric Alert on appGateway for FailedRequests (Current FailedRequests of the Application Gateway)"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Network/appGateway"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Network/appGateway"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"FailedRequests"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/appGateway/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Network/appGateway', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-appGateway_FailedRequests')]",
                            "location": "global",
                            "properties": {
                                "description": "Current FailedRequests of the Application Gateway",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Network/appGateway",
                                            "metricName": "FailedRequests",
                                            "dimensions": [
                                                {
                                                    "name": "BackendSettingsPool",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Network/appGateway",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    }                 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "appGateway_TotalRequests" {
  name         = "appGateway_TotalRequests"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on appGateway TotalRequests"
  description  = "Creates an AzMonitor Metric Alert on appGateway for TotalRequests (Current TotalRequests of the Application Gateway)"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Network/appGateway"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Network/appGateway"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"TotalRequests"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/appGateway/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Network/appGateway', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-appGateway_TotalRequests')]",
                            "location": "global",
                            "properties": {
                                "description": "Current TotalRequests of the Application Gateway",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Network/appGateway",
                                            "metricName": "TotalRequests",
                                            "dimensions": [
                                                {
                                                    "name": "BackendSettingsPool",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Network/appGateway",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    }                 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "azureFirewall_Health" {
  name         = "azureFirewall_Health"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on Azure Firewall Health"
  description  = "Creates an AzMonitor Metric Alert on Azure Firewall for Health (Indicates the overall health of this firewall)"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Network/azurefirewalls"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Network/azurefirewalls"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"FirewallHealth"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/azurefirewalls/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Network/azurefirewalls', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-azureFirewall_Health')]",
                            "location": "global",
                            "properties": {
                                "description": "Indicates the overall health of this firewall",
                                "severity": 2,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT1M",
                                "windowSize": "PT30M",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "High",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Network/azurefirewalls",
                                            "metricName": "FirewallHealth",
                                            "dimensions": [
                                                {
                                                    "name": "Status",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                },
                                                {
                                                    "name": "Reason",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "LessThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Network/azurefirewalls",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "loadBalancer_DipAvailability" {
  name         = "loadBalancer_DipAvailability"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on Load Balancer DipAvailability"
  description  = "Creates an AzMonitor Metric Alert on Load Balancers for DipAvailability (Average Load Balancer health probe status per time duration)"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Network/loadBalancers"
        },
        {
          "field": "Microsoft.Network/loadBalancers/sku.name",
          "equals": "Standard"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Network/loadBalancers"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"DipAvailability"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/loadBalancers/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Network/loadBalancers', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-loadBalancer_DipAvailability')]",
                            "location": "global",
                            "properties": {
                                "description": "Average Load Balancer health probe status per time duration",
                                "severity": 2,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Network/loadBalancers",
                                            "metricName": "DipAvailability",
                                            "dimensions": [
                                                {
                                                    "name": "ProtocolType",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                },
                                                {
                                                    "name": "FrontendIPAddress",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                },
                                                {
                                                    "name": "BackendIPAddress",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "LessThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Network/loadBalancers",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "loadBalancer_VipAvailability" {
  name         = "loadBalancer_VipAvailability"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on Load Balancer VipAvailability"
  description  = "Creates an AzMonitor Metric Alert on Load Balancers for VipAvailability (Average Load Balancer data path availability per time duration)"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Network/loadBalancers"
        },
        {
          "field": "Microsoft.Network/loadBalancers/sku.name",
          "equals": "Standard"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Network/loadBalancers"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"VipAvailability"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/loadBalancers/', field('fullName'))]"
                }
            ]
        },
        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Network/loadBalancers', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-loadBalancer_VipAvailability')]",
                            "location": "global",
                            "properties": {
                                "description": "Average Load Balancer data path availability per time duration",
                                "severity": 2,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Network/loadBalancers",
                                            "metricName": "VipAvailability",
                                            "dimensions": [
                                                {
                                                    "name": "FrontendPort",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                },
                                                {
                                                    "name": "FrontendIPAddress",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "LessThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Network/loadBalancers",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "sqlManagedInstances_avgCPUPercent" {
  name         = "sqlManagedInstances_avgCPUPercent"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on sqlManagedInstances avgCPUPercent"
  description  = "Creates an AzMonitor Metric Alert on sqlManagedInstances for avgCPUPercent"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.sql/managedinstances"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.sql/managedinstances"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"avg_cpu_percent"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.sql/managedinstances/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.sql/managedinstances', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-sqlManagedInstances_avgCPUPercent')]",
                            "location": "global",
                            "properties": {
                                "description": "Average CPU percentage",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.sql/managedinstances",
                                            "metricName": "avg_cpu_percent",
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.sql/managedinstances",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "sqlManagedInstances_ioRequests" {
  name         = "sqlManagedInstances_ioRequests"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on sqlManagedInstances ioRequests"
  description  = "Creates an AzMonitor Metric Alert on sqlManagedInstances for ioRequests"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.sql/managedinstances"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.sql/managedinstances"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"io_requests"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.sql/managedinstances/', field('fullName'))]"
                }
            ]
        },
        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.sql/managedinstances', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-sqlManagedInstances_ioRequests')]",
                            "location": "global",
                            "properties": {
                                "description": "IO requests count",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.sql/managedinstances",
                                            "metricName": "io_requests",
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.sql/managedinstances",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "websvrfarm_CpuPercentage" {
  name         = "websvrfarm_CpuPercentage"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on WebServerFarm CpuPercentage"
  description  = "Creates an AzMonitor Metric Alert on WebServerFarm for CpuPercentage"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Web/serverfarms"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Web/serverfarms"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"CpuPercentage"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/serverfarms/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Web/serverfarms', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-websvrfarm_CpuPercentage')]",
                            "location": "global",
                            "properties": {
                                "description": "Average Response Time",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Web/serverfarms",
                                            "metricName": "CpuPercentage",
                                            "dimensions": [
                                                {
                                                    "name": "Instance",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Web/serverfarms",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "websvrfarm_MemoryPercentage" {
  name         = "websvrfarm_MemoryPercentage"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on WebServerFarm MemoryPercentage"
  description  = "Creates an AzMonitor Metric Alert on WebServerFarm for MemoryPercentage"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Web/serverfarms"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Web/serverfarms"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"MemoryPercentage"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/serverfarms/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Web/serverfarms', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-websvrfarm_MemoryPercentage')]",
                            "location": "global",
                            "properties": {
                                "description": "Average Response Time",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Web/serverfarms",
                                            "metricName": "MemoryPercentage",
                                            "dimensions": [
                                                {
                                                    "name": "Instance",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Web/serverfarms",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "website_AverageMemoryWorkingSet" {
  name         = "website_AverageMemoryWorkingSet"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on Website AverageMemoryWorkingSet"
  description  = "Creates an AzMonitor Metric Alert on Websites for AverageMemoryWorkingSet"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Web/sites"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Web/sites"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"AverageMemoryWorkingSet"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Web/sites', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-website_AverageMemoryWorkingSet')]",
                            "location": "global",
                            "properties": {
                                "description": "Average Response Time",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Web/sites",
                                            "metricName": "AverageMemoryWorkingSet",
                                            "dimensions": [
                                                {
                                                    "name": "Instance",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Web/sites",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "website_AverageResponseTime" {
  name         = "website_AverageResponseTime"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on Website AverageResponseTime"
  description  = "Creates an AzMonitor Metric Alert on Websites for AverageResponseTime"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Web/sites"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Web/sites"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"AverageResponseTime"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Web/sites', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-website_AverageResponseTime')]",
                            "location": "global",
                            "properties": {
                                "description": "Average Response Time",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Web/sites",
                                            "metricName": "AverageResponseTime",
                                            "dimensions": [
                                                {
                                                    "name": "Instance",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Web/sites",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "website_CpuTime" {
  name         = "website_CpuTime"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on Website CpuTime"
  description  = "Creates an AzMonitor Metric Alert on Websites for CpuTime"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Web/sites"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Web/sites"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"CpuTime"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Web/sites', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-website_CpuTime')]",
                            "location": "global",
                            "properties": {
                                "description": "CPU Time",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Low",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Web/sites",
                                            "metricName": "CpuTime",
                                            "dimensions": [
                                                {
                                                    "name": "Instance",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Total",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Web/sites",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "website_HealthCheckStatus" {
  name         = "website_HealthCheckStatus"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on Website HealthCheckStatus"
  description  = "Creates an AzMonitor Metric Alert on Websites for HealthCheckStatus"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Web/sites"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Web/sites"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"HealthCheckStatus"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Web/sites', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-website_HealthCheckStatus')]",
                            "location": "global",
                            "properties": {
                                "description": "Health Check Status",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Web/sites",
                                            "metricName": "HealthCheckStatus",
                                            "dimensions": [
                                                {
                                                    "name": "Instance",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "LessThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Web/sites",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "website_Http5xx" {
  name         = "website_Http5xx"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on Website Http5xx"
  description  = "Creates an AzMonitor Metric Alert on Websites for Http5xx"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Web/sites"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Web/sites"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"Http5xx"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Web/sites', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-website_Http5xx')]",
                            "location": "global",
                            "properties": {
                                "description": "Http Server Errors",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Web/sites",
                                            "metricName": "Http5xx",
                                            "dimensions": [
                                                {
                                                    "name": "Instance",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Total",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Web/sites",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "website_RequestsInApplicationQueue" {
  name         = "website_RequestsInApplicationQueue"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on Website RequestsInApplicationQueue"
  description  = "Creates an AzMonitor Metric Alert on Websites for RequestsInApplicationQueue"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Web/sites"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Web/sites"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"RequestsInApplicationQueue"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Web/sites', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-website_RequestsInApplicationQueue')]",
                            "location": "global",
                            "properties": {
                                "description": "Requests In Application Queue",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Web/sites",
                                            "metricName": "RequestsInApplicationQueue",
                                            "dimensions": [
                                                {
                                                    "name": "Instance",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Web/sites",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "websiteSlot_AverageMemoryWorkingSet" {
  name         = "websiteSlot_AverageMemoryWorkingSet"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on Website Slots AverageMemoryWorkingSet"
  description  = "Creates an AzMonitor Metric Alert on Website Slots AverageMemoryWorkingSet"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Web/sites/slots"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Web/sites/slots"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"AverageMemoryWorkingSet"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/slots/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Web/sites/slots', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-websiteSlot_AverageMemoryWorkingSet')]",
                            "location": "global",
                            "properties": {
                                "description": "AverageMemoryWorkingSet",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Web/sites/slots",
                                            "metricName": "AverageMemoryWorkingSet",
                                            "dimensions": [
                                                {
                                                    "name": "Instance",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Web/sites/slots",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "websiteSlot_AverageResponseTime" {
  name         = "websiteSlot_AverageResponseTime"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on Website Slots AverageResponseTime"
  description  = "Creates an AzMonitor Metric Alert on Website Slots AverageResponseTime"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Web/sites/slots"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Web/sites/slots"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"AverageResponseTime"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/slots/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Web/sites/slots', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-websiteSlot_AverageResponseTime')]",
                            "location": "global",
                            "properties": {
                                "description": "AverageResponseTime",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Web/sites/slots",
                                            "metricName": "AverageResponseTime",
                                            "dimensions": [
                                                {
                                                    "name": "Instance",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Web/sites/slots",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "websiteSlot_CpuTime" {
  name         = "websiteSlot_CpuTime"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on Website Slots CpuTime"
  description  = "Creates an AzMonitor Metric Alert on Website Slots CpuTime"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Web/sites/slots"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Web/sites/slots"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"CpuTime"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/slots/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Web/sites/slots', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-websiteSlot_CpuTime')]",
                            "location": "global",
                            "properties": {
                                "description": "CpuTime",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Web/sites/slots",
                                            "metricName": "CpuTime",
                                            "dimensions": [
                                                {
                                                    "name": "Instance",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Total",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Web/sites/slots",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "websiteSlot_HealthCheckStatus" {
  name         = "websiteSlot_HealthCheckStatus"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on Website Slots HealthCheckStatus"
  description  = "Creates an AzMonitor Metric Alert on Website Slots HealthCheckStatus"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Web/sites/slots"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Web/sites/slots"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"HealthCheckStatus"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/slots/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Web/sites/slots', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-websiteSlot_HealthCheckStatus')]",
                            "location": "global",
                            "properties": {
                                "description": "HealthCheckStatus",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Web/sites/slots",
                                            "metricName": "HealthCheckStatus",
                                            "dimensions": [
                                                {
                                                    "name": "Instance",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "LessThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Web/sites/slots",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "websiteSlot_Http5xx" {
  name         = "websiteSlot_Http5xx"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on Website Slots Http5xx"
  description  = "Creates an AzMonitor Metric Alert on Website Slots Http5xx (Http Server Errors)"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Web/sites/slots"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Web/sites/slots"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"Http5xx"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/slots/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Web/sites/slots', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-websiteSlot_Http5xx')]",
                            "location": "global",
                            "properties": {
                                "description": "Http5xx",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Web/sites/slots",
                                            "metricName": "Http5xx",
                                            "dimensions": [
                                                {
                                                    "name": "Instance",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Total",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Web/sites/slots",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}

resource "azurerm_policy_definition" "websiteSlot_RequestsInApplicationQueue" {
  name         = "websiteSlot_RequestsInApplicationQueue"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AzMonitor Alert on Website Slots RequestsInApplicationQueue"
  description  = "Creates an AzMonitor Metric Alert on Website Slots RequestsInApplicationQueue"
  metadata     = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA
  policy_rule  = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Web/sites/slots"
        }
      ]
    },
    "then": {
      "effect": "deployIfNotExists",
      "details": {
        "roleDefinitionIds": [
          "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
        "type":"Microsoft.Insights/metricAlerts",
        "existenceCondition": {
            "allOf": [
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                    "equals":"Microsoft.Web/sites/slots"
                },
                {
                    "field":"Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                    "equals":"RequestsInApplicationQueue"
                },
                {
                    "field":"Microsoft.Insights/metricalerts/scopes[*]",
                    "equals":"[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/slots/', field('fullName'))]"
                }
            ]
        },

        "deployment": {
            "properties": {
                "mode": "incremental",
                "template": {
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {
                        "resourceName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceName",
                                "description": "Name of the resource"
                            }
                        },
                        "actionGroupName": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupName",
                                "description": "Name of the Action Group"
                            }
                        },
                        "actionGroupRG": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupRG",
                                "description": "Resource Group containing the Action Group"
                            }
                        },
                        "resourceId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceId",
                                "description": "Resource ID of the resource emitting the metric that will be used for the comparison"
                            },
                            "defaultValue": "[resourceId('Microsoft.Web/sites/slots', parameters('resourceName'))]"
                        },
                        "resourceLocation": {
                            "type": "string",
                            "metadata": {
                                "displayName": "resourceLocation",
                                "description": "Location of the resource"
                            }
                        },
                        "actionGroupId": {
                            "type": "string",
                            "metadata": {
                                "displayName": "actionGroupId",
                                "description": "The ID of the action group that is triggered when the alert is activated or deactivated"
                            },
                            "defaultValue": "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                        }
                     },
                    "variables": {},
                    "resources": [
                        {
                            "type": "Microsoft.Insights/metricAlerts",
                            "apiVersion": "2018-03-01",
                            "name": "[concat(parameters('resourceName'), '-websiteSlot_RequestsInApplicationQueue')]",
                            "location": "global",
                            "properties": {
                                "description": "Requests In Application Queue",
                                "severity": 3,
                                "enabled": true,
                                "scopes": ["[parameters('resourceId')]"],
                                "evaluationFrequency": "PT15M",
                                "windowSize": "PT1H",
                                "criteria": {
                                    "allOf": [
                                        {
                                            "alertSensitivity": "Medium",
                                            "failingPeriods": {
                                                "numberOfEvaluationPeriods": 2,
                                                "minFailingPeriodsToAlert": 1
                                            },
                                            "name": "Metric1",
                                            "metricNamespace": "Microsoft.Web/sites/slots",
                                            "metricName": "RequestsInApplicationQueue",
                                            "dimensions": [
                                                {
                                                    "name": "Instance",
                                                    "operator": "Include",
                                                    "values": [
                                                        "*"
                                                    ]
                                                }
                                            ],
                                            "operator": "GreaterThan",
                                            "timeAggregation": "Average",
                                            "criterionType": "DynamicThresholdCriterion"
                                        }
                                    ],
                                    "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                },
                                "autoMitigate": true,
                                "targetResourceType": "Microsoft.Web/sites/slots",
                                "targetResourceRegion": "[parameters('resourceLocation')]",
                                "actions": [
                                    {
                                        "actionGroupId": "[parameters('actionGroupId')]",
                                        "webHookProperties": {}
                                    }
                                ]
                            }
                        }
                    ]
                },
                "parameters": {
                    "resourceName": {
                        "value": "[field('fullName')]"
                    },
                    "resourceLocation": {
                        "value": "[field('location')]"
                    },
                    "actionGroupName": {
                        "value": "${var.azure_monitor_action_group_name}"
                    },
                    "actionGroupRG": {
                        "value": "${var.azure_monitor_action_group_rg_name}"
                    } 
                }
            }
        }
      }
    }
  }

POLICY_RULE
}