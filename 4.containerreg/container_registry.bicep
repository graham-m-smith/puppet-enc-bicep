param container_reg_name string
param location string = resourceGroup().location

param tag_values object = {
  Department: 'Infrastructure'
  Business_Unit: 'DTS'
  Environment: 'DEV'
  DeployMethod: 'Bicep'
  LastDeploy: utcNow('d')
  Project: 'Puppet-ENC'
}

resource containerreg 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: container_reg_name
  location: location
  tags: tag_values
  sku: {
    name: 'Standard'
  }
  properties: {
    adminUserEnabled: true
  }
}
