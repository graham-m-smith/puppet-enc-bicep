param fa_name string
param location string
param tag_values object
param keyvault_name string
param keyvault_rg string

var storageAccountName = 'sapefasapi${uniqueString(resourceGroup().id)}' 
var hostingPlanName = '${fa_name}${uniqueString(resourceGroup().id)}'
var appInsightsName = '${fa_name}${uniqueString(resourceGroup().id)}'
var functionAppName = fa_name

// Create storage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  tags: tag_values
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

// Create application insights
resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: { 
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
  tags: {
    // circular dependency means we can't reference functionApp directly  /subscriptions/<subscriptionId>/resourceGroups/<rg-name>/providers/Microsoft.Web/sites/<appName>"
     'hidden-link:/subscriptions/${subscription().id}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Web/sites/${functionAppName}': 'Resource'
  }
}

// Create hosting plan
resource hostingPlan 'Microsoft.Web/serverfarms@2020-10-01' = {
  name: hostingPlanName
  location: location
  tags: tag_values
  kind: 'linux'
  properties: {
    reserved: true    // THIS IS REQUIRED FOR LINUX FUNCTION APPS !!!!
  }
  sku: {
    name: 'Y1' 
    tier: 'Dynamic'
  }
}

// Create function app
resource functionApp 'Microsoft.Web/sites@2020-06-01' = {
  name: functionAppName
  location: location
  tags: tag_values
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    httpsOnly: true
    serverFarmId: hostingPlan.id
    clientAffinityEnabled: true
    siteConfig: {
      use32BitWorkerProcess: false
      linuxFxVersion: 'PYTHON|3.9'
      pythonVersion: '3.9'
      appSettings: [
        {
          'name': 'APPINSIGHTS_INSTRUMENTATIONKEY'
          'value': appInsights.properties.InstrumentationKey
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        {
          'name': 'FUNCTIONS_EXTENSION_VERSION'
          'value': '~4'
        }
        {
          'name': 'FUNCTIONS_WORKER_RUNTIME'
          'value': 'python'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        {
          name: 'ENC_UI_KEYVAULT'
          value: keyvault_name
        }
        // WEBSITE_CONTENTSHARE will also be auto-generated - https://docs.microsoft.com/en-us/azure/azure-functions/functions-app-settings#website_contentshare
        // WEBSITE_RUN_FROM_PACKAGE will be set to 1 by func azure functionapp publish
      ]
    }
  }

  dependsOn: [
    appInsights
    hostingPlan
    storageAccount
  ]
}

// Set-up source control 
// var repositoryUrl = 'https://github.com/graham-m-smith/puppet-enc-api-azfunc.git'
// var branch = 'master'

// resource srcControls 'Microsoft.Web/sites/sourcecontrols@2021-01-01' = {
//   name: '${functionApp.name}/web'
//   properties: {
//     repoUrl: repositoryUrl
//     branch: branch
//     isManualIntegration: true
//   }
// }

module kvaccess '../modules/keyvault_access.bicep' = {
  name: 'fa-kv-access'
  scope: resourceGroup(keyvault_rg)
  params: {
    object_id: functionApp.identity.principalId
    keyvault_name: keyvault_name
  }
}
