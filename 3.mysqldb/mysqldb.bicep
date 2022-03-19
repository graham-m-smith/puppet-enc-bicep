param mysqldb_name string = 'mysqldb-puppetenc-gmsdev'
param location string = 'uksouth'
param puppetenc_db_name string = 'puppetenc'

param keyvault_name string = 'kv-puppetenc'

// Reference to KeyVault
resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyvault_name
}

// Call module to create MySQL Database
module mysqldb 'mysqldb_create.bicep' = {
  name: mysqldb_name
  params: {
    location: location
    puppetenc_db_name: puppetenc_db_name
    administratorLoginPassword: keyvault.getSecret('MYSQL-ADMIN-PASSWORD')
    mysqldb_name: mysqldb_name
  }
}
