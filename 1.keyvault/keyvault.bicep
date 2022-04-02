param keyvault_name string
param location string = resourceGroup().location
param aduser string

param tag_values object = {
  Department: 'Infrastructure'
  Business_Unit: 'DTS'
  Environment: 'DEV'
  DeployMethod: 'Bicep'
  LastDeploy: utcNow('d')
  Project: 'Puppet-ENC'
}

// Key Vault for Puppet ENC
resource keyvault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyvault_name
  location: location
  tags: tag_values
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: aduser
        permissions: {
          keys: [
            'all'
          ]
          secrets: [ 
            'all'
          ]
          certificates: [
            'all'
          ]
        }
      }
    ]
  }

}
