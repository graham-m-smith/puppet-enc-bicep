param fa_name string
param location string = resourceGroup().location
param keyvault_name string
param keyvault_rg string

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

module webapp 'function_app_create.bicep' = {
  name: fa_name
  params: {
    fa_name: fa_name
    location: location
    tag_values: tag_values
    keyvault_name: keyvault_name
    keyvault_rg: keyvault_rg
  }
}

