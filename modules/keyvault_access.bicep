param keyvault_name string
param object_id string

// Reference to KeyVault
resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyvault_name
}

// Grant function app secrets/get access policy on keyvault
resource kvaccesspolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-11-01-preview' = {
  parent: keyvault
  name: 'replace'
  properties: {
    accessPolicies: [
      {
        objectId: object_id
        tenantId: subscription().tenantId
        permissions: {
          secrets: [
            'get'
          ]
          keys: []
          certificates: []
        }
      }
    
    ]
  }
}

