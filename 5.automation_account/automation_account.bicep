param aa_name string
param location string = resourceGroup().location
param keyvault_name string
param container_rg_name string

// Reference to KeyVault
resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyvault_name
}

// Create Automation Account
resource aa 'Microsoft.Automation/automationAccounts@2021-06-22' = {
  name: aa_name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: true
    disableLocalAuth: false
    sku: {
      name: 'Basic'
    }
  }
}

// Grant automation account secrets/get access policy on keyvault
resource kvaccesspolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-11-01-preview' = {
  parent: keyvault
  name: 'replace'
  properties: {
    accessPolicies: [
      {
        objectId: aa.identity.principalId
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

// Grant automation account contributor role on containers resource group
module roleassign '../modules/role_assignment.bicep' = {
  name: 'container-rg-role-assign'
  scope: resourceGroup(container_rg_name)
  params: {
    principal_id: aa.identity.principalId
    role_name: 'Contributor'
  }
}
