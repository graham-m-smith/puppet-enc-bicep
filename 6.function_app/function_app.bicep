param fa_name string
param location string = resourceGroup().location
param container_rg_name string
param keyvault_name string

// Reference to KeyVault
resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyvault_name
}

module webapp 'function_app_create.bicep' = {
  name: fa_name
  params: {
    container_rg_name: container_rg_name
    fa_name: fa_name
    location: location
    sa_connection_string: keyvault.getSecret('SA-CONNECTION-STRING')
  }
}

