param wa_name string
param location string = resourceGroup().location
param keyvault_name string
param repositoryUrl string
param branch string

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
  }
}
