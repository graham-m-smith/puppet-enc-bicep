param location string = resourceGroup().location
param vnetName string = 'vnet-puppetlab'
param subnetName string = 'subnet-container'

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-03-01' = {
  name: 'cg-puppet-enc-api-test'
  location: location
  properties: {
    imageRegistryCredentials: [
      {
        server: 'cregpuppetencgmsdev.azurecr.io'
        username: 'cregpuppetencgmsdev'
        password: ''
      }
    ]
    containers: [
      {
        name: 'cg-puppet-enc-api-test'
        properties: {
          image: 'cregpuppetencgmsdev.azurecr.io/puppet-enc-api:v1'
          
          ports: [
            {
              port: 443
            }
          ]
          environmentVariables: [
            {
              name: 'ENC_UI_KEYVAULT'
              value: 'kv-puppetenc'
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 2
            }
          }
        }
      }
    ]
    restartPolicy: 'OnFailure'
    osType: 'Linux'
    subnetIDs: [
      {
        id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
      }
    ]
    ipAddress: {
      type: 'Private'
      ports: [
        {
          protocol: 'TCP'
          port: 80
        }
      ]
      ip: '10.128.3.5'
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}
