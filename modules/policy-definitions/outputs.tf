output "sqlManagedInstances_ioRequests_policy_id" {
  value       = azurerm_policy_definition.sqlManagedInstances_ioRequests.id
  description = "The policy definition id for sqlManagedInstances_ioRequests"
}

output "sqlManagedInstances_avgCPUPercent_policy_id" {
  value       = azurerm_policy_definition.sqlManagedInstances_avgCPUPercent.id
  description = "The policy definition id for sqlManagedInstances_avgCPUPercent"
}

output "appGateway_HealthyHostCount_policy_id" {
  value       = azurerm_policy_definition.appGateway_HealthyHostCount.id
  description = "The policy definition id for appGateway_HealthyHostCount"
}

output "appGateway_UnhealthyHostcount_policy_id" {
  value       = azurerm_policy_definition.appGateway_UnhealthyHostcount.id
  description = "The policy definition id for appGateway_UnhealthyHostcount"
}

output "appGateway_FailedRequests_policy_id" {
  value       = azurerm_policy_definition.appGateway_FailedRequests.id
  description = "The policy definition id for appGateway_FailedRequests"
}

output "appGateway_TotalRequests_policy_id" {
  value       = azurerm_policy_definition.appGateway_TotalRequests.id
  description = "The policy definition id for appGateway_TotalRequests"
}

output "appGateway_ClientRtt_policy_id" {
  value       = azurerm_policy_definition.appGateway_ClientRtt.id
  description = "The policy definition id for appGateway_ClientRtt"
}

output "appGateway_CpuUtilization_policy_id" {
  value       = azurerm_policy_definition.appGateway_CpuUtilization.id
  description = "The policy definition id for appGateway_CpuUtilization"
}

output "websvrfarm_CpuPercentage_policy_id" {
  value       = azurerm_policy_definition.websvrfarm_CpuPercentage.id
  description = "The policy definition id for websvrfarm_CpuPercentage"
}

output "websvrfarm_MemoryPercentage_policy_id" {
  value       = azurerm_policy_definition.websvrfarm_MemoryPercentage.id
  description = "The policy definition id for websvrfarm_MemoryPercentage"
}

output "website_AverageMemoryWorkingSet_policy_id" {
  value       = azurerm_policy_definition.website_AverageMemoryWorkingSet.id
  description = "The policy definition id for website_AverageMemoryWorkingSet"
}

output "website_AverageResponseTime_policy_id" {
  value       = azurerm_policy_definition.website_AverageResponseTime.id
  description = "The policy definition id for website_AverageResponseTime"
}

output "website_CpuTime_policy_id" {
  value       = azurerm_policy_definition.website_CpuTime.id
  description = "The policy definition id for website_CpuTime"
}

output "website_HealthCheckStatus_policy_id" {
  value       = azurerm_policy_definition.website_HealthCheckStatus.id
  description = "The policy definition id for website_HealthCheckStatus"
}

output "website_Http5xx_policy_id" {
  value       = azurerm_policy_definition.website_Http5xx.id
  description = "The policy definition id for website_Http5xx"
}

output "website_RequestsInApplicationQueue_policy_id" {
  value       = azurerm_policy_definition.website_RequestsInApplicationQueue.id
  description = "The policy definition id for website_RequestsInApplicationQueue"
}

output "websiteSlot_AverageMemoryWorkingSet_policy_id" {
  value       = azurerm_policy_definition.websiteSlot_AverageMemoryWorkingSet.id
  description = "The policy definition id for websiteSlot_AverageMemoryWorkingSet"
}

output "websiteSlot_AverageResponseTime_policy_id" {
  value       = azurerm_policy_definition.websiteSlot_AverageResponseTime.id
  description = "The policy definition id for websiteSlot_AverageResponseTime"
}

output "websiteSlot_CpuTime_policy_id" {
  value       = azurerm_policy_definition.websiteSlot_CpuTime.id
  description = "The policy definition id for websiteSlot_CpuTime"
}

output "websiteSlot_HealthCheckStatus_policy_id" {
  value       = azurerm_policy_definition.websiteSlot_HealthCheckStatus.id
  description = "The policy definition id for websiteSlot_HealthCheckStatus"
}

output "websiteSlot_Http5xx_policy_id" {
  value       = azurerm_policy_definition.websiteSlot_Http5xx.id
  description = "The policy definition id for websiteSlot_Http5xx"
}

output "websiteSlot_RequestsInApplicationQueue_policy_id" {
  value       = azurerm_policy_definition.websiteSlot_RequestsInApplicationQueue.id
  description = "The policy definition id for websiteSlot_RequestsInApplicationQueue"
}

output "azureFirewall_Health_policy_id" {
  value       = azurerm_policy_definition.azureFirewall_Health.id
  description = "The policy definition id for azureFirewall_Health"
}

output "loadBalancer_DipAvailability_policy_id" {
  value       = azurerm_policy_definition.loadBalancer_DipAvailability.id
  description = "The policy definition id for loadBalancer_DipAvailability"
}

output "loadBalancer_VipAvailability_policy_id" {
  value       = azurerm_policy_definition.loadBalancer_VipAvailability.id
  description = "The policy definition id for loadBalancer_VipAvailability"
}

output "addTagToRG_policy_ids" {
  value       = azurerm_policy_definition.addTagToRG.*.id
  description = "The policy definition ids for addTagToRG policies"
}

output "inheritTagFromRG_policy_ids" {
  value       = azurerm_policy_definition.inheritTagFromRG.*.id
  description = "The policy definition ids for inheritTagFromRG policies"
}

output "inheritTagFromRGOverwriteExisting_policy_ids" {
  value       = azurerm_policy_definition.inheritTagFromRGOverwriteExisting.*.id
  description = "The policy definition ids for inheritTagFromRGOverwriteExisting policies"
}

output "bulkInheritTagsFromRG_policy_id" {
  value       = azurerm_policy_definition.bulkInheritTagsFromRG.id
  description = "The policy definition id for bulkInheritTagsFromRG"
}

output "auditRoleAssignmentType_user_policy_id" {
  value       = azurerm_policy_definition.auditRoleAssignmentType_user.id
  description = "The policy definition id for auditRoleAssignmentType_user"
}

output "auditLockOnNetworking_policy_id" {
  value       = azurerm_policy_definition.auditLockOnNetworking.id
  description = "The policy definition id for auditLockOnNetworking"
}