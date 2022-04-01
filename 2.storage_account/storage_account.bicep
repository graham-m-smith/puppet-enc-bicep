param sa_name string
param location string = resourceGroup().location
param config_container_name string
param facts_container_name string
param syncdb_container_name string
param keyvault_name string
param connection_string_secret_name string

// Storage Account
resource sa 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: sa_name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    routingPreference: {
      routingChoice: 'MicrosoftRouting'
    }
  }
}

// Container for ENC Config YAML Files
resource config_container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${sa.name}/default/${config_container_name}'
  properties: {}
}

// Container for ENC Facts YAML File
resource facts_container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${sa.name}/default/${facts_container_name}'
  properties: {}
}

// Container for ENC SyncDB JSON File
resource syncdb_container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${sa.name}/default/${syncdb_container_name}'
  properties: {}
}

// Reference to KeyVault
resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyvault_name
}

// Store the connection string in Keyvault
resource storageAccountConnectionString 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyvault.name}/${connection_string_secret_name}'
  properties: {
    value: 'DefaultEndpointsProtocol=https;AccountName=${sa.name};AccountKey=${listKeys(sa.id, sa.apiVersion).keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
  }
}
