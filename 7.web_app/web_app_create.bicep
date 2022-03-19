param wa_name string
param location string
param keyvault_name string
param mysqldb_name string

@secure()
param enc_database_type string
@secure()
param enc_db_name string
@secure()
param enc_db_port string
@secure()
param enc_db_ssl_ca string
@secure()
param enc_db_user string
@secure()
param enc_duo_api_hostname string
@secure()
param enc_duo_enabled string
@secure()
param enc_duo_failmode string
@secure()
param enc_duo_redirect_url string
@secure()
param enc_secret_key string
@secure()
param enc_db_pass string
@secure()
param enc_duo_client_id string
@secure()
param enc_duo_client_secret string

var hostingPlanName = 'ASP-${wa_name}${uniqueString(resourceGroup().id)}'

// Reference to MySQL Database
resource mysqldb 'Microsoft.DBforMySQL/flexibleServers@2021-05-01' existing = {
  name: mysqldb_name
}

// Reference to KeyVault
resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyvault_name
}

// Get MySQL DB FQDN
var enc_db_host = mysqldb.properties.fullyQualifiedDomainName

// App Service Plan
resource hostingPlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: hostingPlanName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource webapp 'Microsoft.Web/sites@2021-03-01' = {
  name: wa_name
  location: location
  kind: 'app.linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    serverFarmId: hostingPlan.id
    reserved: true
    isXenon: false
    hyperV: false
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: 'PYTHON|3.8'
      acrUseManagedIdentityCreds: false
      alwaysOn: true
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 1
      appSettings: [
        {
          name: 'PUPPET_ENC_UI_DATABASE_TYPE'
          value: enc_database_type
        }
        {
          name: 'PUPPET_ENC_UI_DB_HOST'
          value: enc_db_host
        }
        {
          name: 'PUPPET_ENC_UI_DB_NAME'
          value: enc_db_name
        }
        {
          name: 'PUPPET_ENC_UI_DB_PASS'
          value: enc_db_pass
        }
        {
          name: 'PUPPET_ENC_UI_DB_PORT'
          value: enc_db_port
        }
        {
          name: 'PUPPET_ENC_UI_DB_SSL_CA'
          value: enc_db_ssl_ca
        }
        {
          name: 'PUPPET_ENC_UI_DB_USER'
          value: enc_db_user
        }
        {
          name: 'PUPPET_ENC_UI_DUO_API_HOSTNAME'
          value: enc_duo_api_hostname
        }
        {
          name: 'PUPPET_ENC_UI_DUO_CLIENT_ID'
          value: enc_duo_client_id
        }
        {
          name: 'PUPPET_ENC_UI_DUO_CLIENT_SECRET'
          value: enc_duo_client_secret
        }
        {
          name: 'PUPPET_ENC_UI_DUO_ENABLED'
          value: enc_duo_enabled
        }
        {
          name: 'PUPPET_ENC_UI_DUO_FAILMODE'
          value: enc_duo_failmode
        }
        {
          name: 'PUPPET_ENC_UI_DUO_REDIRECT_URL'
          value: enc_duo_redirect_url
        }
        {
          name: 'PUPPET_ENC_UI_SECRET_KEY'
          value: enc_secret_key
        }
      ]
    }
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}


// Set-up source control 
var repositoryUrl = 'https://github.com/graham-m-smith/puppet-enc-ui.git'
var branch = 'main'

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2021-01-01' = {
  name: '${webapp.name}/web'
  properties: {
    repoUrl: repositoryUrl
    branch: branch
    isManualIntegration: true
  }
}

// Grant webapp secrets/get access policy on keyvault
resource kvaccesspolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-11-01-preview' = {
  parent: keyvault
  name: 'replace'
  properties: {
    accessPolicies: [
      {
        objectId: webapp.identity.principalId
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
