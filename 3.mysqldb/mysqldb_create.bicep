param location string
param mysqldb_name string 
param puppetenc_db_name string

@secure()
param administratorLoginPassword string

@secure()
param macbook_ip string

param tag_values object

param administratorLogin string = 'mysqladmin'
param serverEdition string = 'Burstable'
param vCores int = 4
param storageSizeGB int = 20
param haEnabled string = 'Disabled'
param availabilityZone string = ''
param standbyAvailabilityZone string = ''
param version string = '8.0.21'
param tags object = {}
param backupRetentionDays int = 7
param geoRedundantBackup string = 'Disabled'
param vmName string = 'Standard_B1ms'
param publicNetworkAccess string = 'Enabled'
param storageIops int = 360
param storageAutogrow string = 'Enabled'

param vnetData object = {
  virtualNetworkName: 'testVnet'
  subnetName: 'testSubnet'
  virtualNetworkAddressPrefix: '10.0.0.0/16'
  virtualNetworkResourceGroupName: resourceGroup().name
  location: 'eastus2'
  subscriptionId: subscription().subscriptionId
  subnetProperties: {}
  isNewVnet: false
  subnetNeedsUpdate: false
  Network: {}
}
param identityData object = {}
param dataEncryptionData object = {}

resource mysqldb 'Microsoft.DBforMySQL/flexibleServers@2021-05-01' = {
  location: location
  name: mysqldb_name
  identity: (empty(identityData) ? json('null') : identityData)
  properties: {
    version: version
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    publicNetworkAccess: publicNetworkAccess
    network: (empty(vnetData.Network) ? json('null') : vnetData.Network)
    storage: {
      storageSizeGB: storageSizeGB
      iops: storageIops
      autoGrow: storageAutogrow
    }
    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
    }
    availabilityZone: availabilityZone
    highAvailability: {
      mode: haEnabled
      standbyAvailabilityZone: standbyAvailabilityZone
    }
    dataEncryption: (empty(dataEncryptionData) ? json('null') : dataEncryptionData)
  }
  sku: {
    name: vmName
    tier: serverEdition
    capacity: vCores
  }
  tags: tag_values
}

resource puppetenc 'Microsoft.DBforMySQL/flexibleServers/databases@2021-05-01' = {
  name: '${mysqldb.name}/${puppetenc_db_name}'
  properties: {
    charset: 'utf8mb4'
    collation: 'utf8mb4_0900_ai_ci'
  }
  dependsOn: [
    mysqldb
  ]
}


// Allow Access from all Azure F/W Rule
resource mysqldb_fwrules_allazure 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2021-05-01' = {
  name: '${mysqldb.name}/allazure'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
  dependsOn: [
    mysqldb
  ]
}

// Allow access from my MacBook
resource mysqldb_fwrules_macbook 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2021-05-01' = {
  name: '${mysqldb.name}/macbook'
  properties: {
    endIpAddress: macbook_ip
    startIpAddress: macbook_ip
  }
  dependsOn: [
    mysqldb
  ]
}
