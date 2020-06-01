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
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/a451c1ef-c6ca-483d-87ed-f49761e3ffb5"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/10ee2ea2-fb4d-45b8-a7e9-a2e770044cd9"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/6b1cbf55-e8b6-442f-ba4c-7246b6381474"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/ebb62a0c-3560-49e1-89ed-27e074e9f8ad"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/f8456c1c-aa66-4dfb-861a-25d127b775c9"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/5f76cf89-fbf2-47fd-a3f4-b891fa780b60"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/5c607a2e-c700-4744-8254-d77e7c9eb5e4"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/aa633080-8b72-40c4-a2d7-d00c03e80bed"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/9297c21d-2ed6-4474-b48f-163f75654ce3"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/e3576e28-8b17-4677-84c3-db2990658d64"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/09024ccc-0c5f-475e-9457-b7c0d9ed487b"
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
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/4f4f78b8-e367-4b10-a341-d9a4ad5cf1c7"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/9daedab3-fb2d-461e-b861-71790eead4f6"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/3657f5a0-770e-44a3-b44e-9431ba1e9735"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/7796937f-307b-4598-941c-67d3a05ebfe7"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/0961003e-5a0a-4549-abde-af6a37f2724d"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/0b15565f-aa9e-48ba-8619-45960f2c314d"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/ac076320-ddcf-4066-b451-6154267e8ad2"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/35f9c03a-cc27-418e-9c0c-539ff999d010"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/f6de0be7-9a8a-4b8a-b349-43cf02d22f7c"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/e372f825-a257-4fb8-9175-797a8a8627d6"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/2c89a2e5-7285-40fe-afe0-ae8654b92fab"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/c9d007d0-c057-4772-b18c-01e546713bcd"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/34c877ad-507e-4c82-993e-3452a6e0ad3c"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/e71308d3-144b-4262-b144-efdc3cc90517"
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
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/013e242c-8828-4970-87b3-ab247555486d"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/d38fc420-0735-4ef3-ac11-c806f651a570"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/0015ea4d-51ff-4ce3-8d8c-f3f8f0179a56"
        },
        {
            "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/0b60c0b2-2dc2-4e1c-b5c9-abbed971de53"
        }
]
POLICY_DEFINITIONS
}
