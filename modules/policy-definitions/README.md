# AzureRM Policy Definitions - Terraform child module

Get in touch :octocat:

* Twitter: [@GitBao](https://twitter.com/gitbao)
* LinkedIn: [@JesseLoudon](https://www.linkedin.com/in/jesseloudon/)
* Web: [jloudon.com](https://jloudon.com)
* GitHub: [@JesseLoudon](https://github.com/jesseloudon)

Learning resources :books:

* [https://www.terraform.io/docs/providers/azurerm/r/policy_definition.html](https://www.terraform.io/docs/providers/azurerm/r/policy_definition.html)
* [https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure)

## Terraform child module files

* `main.tf`
* `outputs.tf`
* `variables.tf`

## Terraform resources (main.tf)

| Resource Type             | Resource name                              | Deployment Count
|:--------------------------|:-------------------------------------------|:------
| azurerm_policy_definition | `addTagToRG`                               | 6
| azurerm_policy_definition | `inheritTagFromRG`                         | 6
| azurerm_policy_definition | `inheritTagFromRGOverwriteExisting`        | 6
| azurerm_policy_definition | `bulkInheritTagsFromRG`                    | 1
| azurerm_policy_definition | `auditRoleAssignmentType_user`             | 1
| azurerm_policy_definition | `appGateway_CpuUtilization`                | 1
| azurerm_policy_definition | `appGateway_ClientRtt`                     | 1
| azurerm_policy_definition | `appGateway_UnhealthyHostcount`            | 1
| azurerm_policy_definition | `appGateway_HealthyHostCount`              | 1
| azurerm_policy_definition | `appGateway_FailedRequests`                | 1
| azurerm_policy_definition | `appGateway_TotalRequests`                 | 1
| azurerm_policy_definition | `azureFirewall_Health`                     | 1
| azurerm_policy_definition | `sqlManagedInstances_avgCPUPercent`        | 1
| azurerm_policy_definition | `loadBalancer_VipAvailability`             | 1
| azurerm_policy_definition | `sqlManagedInstances_ioRequests`           | 1
| azurerm_policy_definition | `websvrfarm_CpuPercentage`                 | 1
| azurerm_policy_definition | `websvrfarm_MemoryPercentage`              | 1
| azurerm_policy_definition | `website_AverageMemoryWorkingSet`          | 1
| azurerm_policy_definition | `website_AverageResponseTime`              | 1
| azurerm_policy_definition | `website_CpuTime`                          | 1
| azurerm_policy_definition | `website_HealthCheckStatus`                | 1
| azurerm_policy_definition | `website_Http5xx`                          | 1
| azurerm_policy_definition | `website_RequestsInApplicationQueue`       | 1
| azurerm_policy_definition | `websiteSlot_AverageMemoryWorkingSet`      | 1
| azurerm_policy_definition | `websiteSlot_AverageResponseTime`          | 1
| azurerm_policy_definition | `websiteSlot_CpuTime`                      | 1
| azurerm_policy_definition | `websiteSlot_HealthCheckStatus`            | 1
| azurerm_policy_definition | `websiteSlot_Http5xx`                      | 1
| azurerm_policy_definition | `websiteSlot_RequestsInApplicationQueue`   | 1

## Terraform input variables (variables.tf)

| Name            | Description | Type | Default Value
|:----------------|:------------|:-----|:---------
| `mandatory_tag_keys`| List of mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG','bulkInheritTagsFromRG' | `list` | "Application", "CostCentre", "Environment", "ManagedBy", "Owner", "Support"
| `mandatory_tag_value` | Tag value to include with the mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG','bulkInheritTagsFromRG' | `string` | "TBC"
| `policy_definition_category` | The category to use for all Policy Definitions | `string` | "Custom"
| `azure_monitor_action_group_name` | The name of the Azure Monitor Action Group | `string` | "AlertOperationsGroup"
| `azure_monitor_action_group_rg_name` | Resource Group containing the Azure Monitor Action Group | `string` | "AzMonitorAlertGroups"

## Terraform output variables (outputs.tf)

| Name                     | Description             | Value
|:-------------------------|:------------------------|:----------
| `addTagToRG_policy_ids` | The policy definition ids for addTagToRG policies | azurerm_policy_definition.addTagToRG.*.id
| `inheritTagFromRG_policy_ids` | The policy definition ids for inheritTagFromRG policies | azurerm_policy_definition.inheritTagFromRG.*.id
| `inheritTagFromRGOverwriteExisting_policy_ids` | The policy definition ids for inheritTagFromRGOverwriteExisting policies | azurerm_policy_definition.inheritTagFromRGOverwriteExisting.*.id
| `bulkInheritTagsFromRG_policy_id` | The policy definition id for bulkInheritTagsFromRG | azurerm_policy_definition.bulkInheritTagsFromRG.id
| `auditRoleAssignmentType_user_policy_id` | The policy definition id for auditRoleAssignmentType_user | azurerm_policy_definition.auditRoleAssignmentType_user.id
| `auditLockOnNetworking_policy_id` | The policy definition id for auditLockOnNetworking | azurerm_policy_definition.auditLockOnNetworking.id
| `sqlManagedInstances_ioRequests_policy_id` | The policy definition id for sqlManagedInstances_ioRequests | azurerm_policy_definition.sqlManagedInstances_ioRequests.id
| `sqlManagedInstances_avgCPUPercent_policy_id` | The policy definition id for sqlManagedInstances_avgCPUPercent | azurerm_policy_definition.sqlManagedInstances_avgCPUPercent.id
| `appGateway_HealthyHostCount_policy_id` | The policy definition id for appGateway_HealthyHostCount | azurerm_policy_definition.appGateway_HealthyHostCount.id
| `appGateway_UnhealthyHostCount_policy_id` | The policy definition id for appGateway_UnhealthyHostCount | azurerm_policy_definition.appGateway_UnhealthyHostCount.id
| `appGateway_FailedRequests_policy_id` | The policy definition id for appGateway_FailedRequests |  azurerm_policy_definition.appGateway_FailedRequests.id
| `appGateway_TotalRequests_policy_id` | The policy definition id for appGateway_TotalRequests |  azurerm_policy_definition.appGateway_TotalRequests.id
| `appGateway_ClientRtt_policy_id` | The policy definition id for appGateway_ClientRtt |  azurerm_policy_definition.appGateway_ClientRtt.id
| `appGateway_CpuUtilization_policy_id` | The policy definition id for appGateway_CpuUtilization |  azurerm_policy_definition.appGateway_CpuUtilization.id
| `websvrfarm_CpuPercentage_policy_id` | The policy definition id for websvrfarm_CpuPercentage |  azurerm_policy_definition.websvrfarm_CpuPercentage.id
| `websvrfarm_MemoryPercentage_policy_id` | The policy definition id for websvrfarm_MemoryPercentage |  azurerm_policy_definition.websvrfarm_MemoryPercentage.id
| `website_AverageMemoryWorkingSet_policy_id` | The policy definition id for website_AverageMemoryWorkingSet |  azurerm_policy_definition.website_AverageMemoryWorkingSet.id
| `website_AverageResponseTime_policy_id` | The policy definition id for website_AverageResponseTime |  azurerm_policy_definition.website_AverageResponseTime.id
| `website_CpuTime_policy_id` | The policy definition id for website_CpuTime |  azurerm_policy_definition.website_CpuTime.id
| `website_HealthCheckStatus_policy_id` | The policy definition id for website_HealthCheckStatus |  azurerm_policy_definition.website_HealthCheckStatus.id
| `website_Http5xx_policy_id` | The policy definition id for website_Http5xx|  azurerm_policy_definition.website_Http5xx.id
| `website_RequestsInApplicationQueue_policy_id` | The policy definition id for website_RequestsInApplicationQueue |  azurerm_policy_definition.website_RequestsInApplicationQueue.id
| `websiteSlot_AverageMemoryWorkingSet_policy_id` | The policy definition id for websiteSlot_AverageMemoryWorkingSet |  azurerm_policy_definition.websiteSlot_AverageMemoryWorkingSet.id
| `websiteSlot_AverageResponseTime_policy_id` | The policy definition id for websiteSlot_AverageResponseTime |  azurerm_policy_definition.websiteSlot_AverageResponseTime.id
| `websiteSlot_CpuTime_policy_id` | The policy definition id for websiteSlot_CpuTime |  azurerm_policy_definition.websiteSlot_CpuTimet.id
| `websiteSlot_HealthCheckStatus_policy_id` | The policy definition id for websiteSlot_HealthCheckStatus |  azurerm_policy_definition.websiteSlot_HealthCheckStatus.id
| `websiteSlot_Http5xx_policy_id` | The policy definition id for websiteSlot_Http5xx|  azurerm_policy_definition.websiteSlot_Http5xx.id
| `websiteSlot_RequestsInApplicationQueue_policy_id` | The policy definition id for websiteSlot_RequestsInApplicationQueue|  azurerm_policy_definition.websiteSlot_RequestsInApplicationQueue.id
| `azureFirewall_Health_policy_id` | The policy definition id for azureFirewall_Health |  azurerm_policy_definition.azureFirewall_Health.id
| `loadBalancer_DipAvailability_policy_id` | The policy definition id for loadBalancer_DipAvailability |  azurerm_policy_definition.loadBalancer_DipAvailability.id
| `loadBalancer_VipAvailability_policy_id` | The policy definition id for loadBalancer_VipAvailability |  azurerm_policy_definition.loadBalancer_VipAvailability.id
