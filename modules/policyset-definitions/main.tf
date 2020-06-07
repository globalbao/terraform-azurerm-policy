resource "azurerm_policy_set_definition" "tag_governance" {

  name         = "tag_governance"
  policy_type  = "Custom"
  display_name = "Tag Governance"
  description  = "Contains common Tag Governance policies"

  metadata = <<METADATA
    {
    "category": "${var.policyset_definition_category}"
    }

METADATA

  policy_definitions = <<POLICY_DEFINITIONS
    [
        {
            "policyDefinitionId": "${var.addTagToRG_policy_id_0}"
        },
        {
            "policyDefinitionId": "${var.addTagToRG_policy_id_1}"
        },
        {
            "policyDefinitionId": "${var.addTagToRG_policy_id_2}"
        },     
        {
            "policyDefinitionId": "${var.addTagToRG_policy_id_3}"
        },
        {
            "policyDefinitionId": "${var.addTagToRG_policy_id_4}"
        },
        {
            "policyDefinitionId": "${var.addTagToRG_policy_id_5}"
        },
        {
            "policyDefinitionId": "${var.bulkAddTagsToRG_policy_id}"
        },
        {
            "policyDefinitionId": "${var.bulkInheritTagsFromRG_policy_id}"
        },
        {
            "policyDefinitionId": "${var.inheritTagFromRG_policy_id_0}"
        },
        {
            "policyDefinitionId": "${var.inheritTagFromRG_policy_id_1}"
        },
        {
            "policyDefinitionId": "${var.inheritTagFromRG_policy_id_2}"
        },
        {
            "policyDefinitionId": "${var.inheritTagFromRG_policy_id_3}"
        },
        {
            "policyDefinitionId": "${var.inheritTagFromRG_policy_id_4}"
        },
        {
            "policyDefinitionId": "${var.inheritTagFromRG_policy_id_5}"
        }
    ]
POLICY_DEFINITIONS
}

resource "azurerm_policy_set_definition" "iam_governance" {

  name         = "iam_governance"
  policy_type  = "Custom"
  display_name = "Identity and Access Management Governance"
  description  = "Contains common Identity and Access Management Governance policies"

  metadata = <<METADATA
    {
    "category": "${var.policyset_definition_category}"
    }

METADATA

  policy_definitions = <<POLICY_DEFINITIONS
    [
        {
            "policyDefinitionId": "${var.auditRoleAssignmentType_user_policy_id}"
        },
        {
            "policyDefinitionId": "${var.auditLockOnNetworking_policy_id}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.iam_policyset_definitions.*.id[0]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.iam_policyset_definitions.*.id[1]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.iam_policyset_definitions.*.id[2]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.iam_policyset_definitions.*.id[3]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.iam_policyset_definitions.*.id[4]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.iam_policyset_definitions.*.id[5]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.iam_policyset_definitions.*.id[6]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.iam_policyset_definitions.*.id[7]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.iam_policyset_definitions.*.id[8]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.iam_policyset_definitions.*.id[9]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.iam_policyset_definitions.*.id[10]}"
        }
    ]
POLICY_DEFINITIONS
}

resource "azurerm_policy_set_definition" "security_governance" {

  name         = "security_governance"
  policy_type  = "Custom"
  display_name = "Security Governance"
  description  = "Contains common Security Governance policies"

  metadata = <<METADATA
    {
    "category": "${var.policyset_definition_category}"
    }

METADATA

  policy_definitions = <<POLICY_DEFINITIONS
    [
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[0]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[1]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[2]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[3]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[4]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[5]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[6]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[7]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[8]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[9]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[10]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[11]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[12]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[13]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[14]}"
        }
    ]
POLICY_DEFINITIONS
}

resource "azurerm_policy_set_definition" "data_protection_governance" {

  name         = "data_protection_governance"
  policy_type  = "Custom"
  display_name = "Data Protection Governance"
  description  = "Contains common Data Protection Governance policies"

  metadata = <<METADATA
    {
    "category": "${var.policyset_definition_category}"
    }

METADATA

  policy_definitions = <<POLICY_DEFINITIONS
    [
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.data_protection_policyset_definitions.*.id[0]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.data_protection_policyset_definitions.*.id[1]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.data_protection_policyset_definitions.*.id[2]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.data_protection_policyset_definitions.*.id[3]}"
        }
]
POLICY_DEFINITIONS
}
