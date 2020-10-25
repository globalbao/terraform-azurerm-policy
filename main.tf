terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.33.0"
    }
  }
}

provider "azurerm" {
/*   
  skip_provider_registration = true
  tenant_id       = "your tenant id"
  subscription_id = "your subscription id"
  client_id       = "your service principal appId"
  client_secret   = "your service principal password" 
*/
  features {}
}

module "policy_assignments" {
  source = "./modules/policy-assignments"

  monitoring_governance_policyset_id      = module.policyset_definitions.monitoring_governance_policyset_id
  tag_governance_policyset_id             = module.policyset_definitions.tag_governance_policyset_id
  iam_governance_policyset_id             = module.policyset_definitions.iam_governance_policyset_id
  security_governance_policyset_id        = module.policyset_definitions.security_governance_policyset_id
  data_protection_governance_policyset_id = module.policyset_definitions.data_protection_governance_policyset_id
}

module "policy_definitions" {
  source = "./modules/policy-definitions"

}

module "policyset_definitions" {
  source = "./modules/policyset-definitions"

  custom_policies_monitoring_governance = [
    {
      policyID = module.policy_definitions.sqlManagedInstances_ioRequests_policy_id
    },
    {
      policyID = module.policy_definitions.sqlManagedInstances_avgCPUPercent_policy_id
    },
    {
      policyID = module.policy_definitions.appGateway_FailedRequests_policy_id
    },
    {
      policyID = module.policy_definitions.appGateway_HealthyHostCount_policy_id
    },
    {
      policyID = module.policy_definitions.appGateway_UnhealthyHostcount_policy_id
    },
    {
      policyID = module.policy_definitions.appGateway_TotalRequests_policy_id
    },
    {
      policyID = module.policy_definitions.appGateway_CpuUtilization_policy_id
    },
    {
      policyID = module.policy_definitions.appGateway_ClientRtt_policy_id
    },
    {
      policyID = module.policy_definitions.websvrfarm_CpuPercentage_policy_id
    },
    {
      policyID = module.policy_definitions.websvrfarm_MemoryPercentage_policy_id
    },
    {
      policyID = module.policy_definitions.website_AverageMemoryWorkingSet_policy_id
    },
    {
      policyID = module.policy_definitions.website_AverageResponseTime_policy_id
    },
    {
      policyID = module.policy_definitions.website_CpuTime_policy_id
    },
    {
      policyID = module.policy_definitions.website_HealthCheckStatus_policy_id
    },
    {
      policyID = module.policy_definitions.website_Http5xx_policy_id
    },
    {
      policyID = module.policy_definitions.website_RequestsInApplicationQueue_policy_id
    },
    {
      policyID = module.policy_definitions.websiteSlot_AverageMemoryWorkingSet_policy_id
    },
    {
      policyID = module.policy_definitions.websiteSlot_AverageResponseTime_policy_id
    },
    {
      policyID = module.policy_definitions.websiteSlot_CpuTime_policy_id
    },
    {
      policyID = module.policy_definitions.websiteSlot_HealthCheckStatus_policy_id
    },
    {
      policyID = module.policy_definitions.websiteSlot_Http5xx_policy_id
    },
    {
      policyID = module.policy_definitions.websiteSlot_RequestsInApplicationQueue_policy_id
    },
    {
      policyID = module.policy_definitions.azureFirewall_Health_policy_id
    },
    {
      policyID = module.policy_definitions.loadBalancer_DipAvailability_policy_id
    },
    {
      policyID = module.policy_definitions.loadBalancer_VipAvailability_policy_id
    }
  ]

  custom_policies_tag_governance = [
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[0]
    },
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[1]
    },
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[2]
    },
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[3]
    },
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[4]
    },
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[5]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[0]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[1]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[2]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[3]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[4]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[5]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[0]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[1]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[2]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[3]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[4]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[5]
    },
    {
      policyID = module.policy_definitions.bulkInheritTagsFromRG_policy_id
    }
  ]

  custom_policies_iam_governance = [
    {
      policyID = module.policy_definitions.auditRoleAssignmentType_user_policy_id
    },
    {
      policyID = module.policy_definitions.auditLockOnNetworking_policy_id
    }
  ]
}
