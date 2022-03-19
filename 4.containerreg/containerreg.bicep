param container_reg_name string = 'cregpuppetencgmsdev'
param location string = 'uksouth'

resource containerreg 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: container_reg_name
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    adminUserEnabled: true
  }
}
