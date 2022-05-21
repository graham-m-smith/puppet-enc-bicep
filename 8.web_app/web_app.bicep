param wa_name string
param location string = resourceGroup().location
param keyvault_name string
param repositoryUrl string
param branch string

param tag_values object = {
  Department: 'Infrastructure'
  Business_Unit: 'DTS'
  Environment: 'DEV'
  DeployMethod: 'Bicep'
  LastDeploy: utcNow('d')
  Project: 'Puppet-ENC'
}

// Reference to KeyVault
resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyvault_name
}

module webapp 'web_app_create.bicep' = {
  name: wa_name
  params: {
    location: location
    keyvault_name: keyvault_name
    wa_name: wa_name
    repositoryUrl: repositoryUrl
    branch: branch
    tag_values: tag_values
  }
}
