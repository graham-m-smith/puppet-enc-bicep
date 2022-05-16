param keyvault_name string
param mysqladmin_password string
param MACBOOK_IP string
param ENC_UI_DB_TYPE string
param ENC_UI_DB_USER string
param ENC_UI_DB_PASS string
param ENC_UI_DB_NAME string
param ENC_UI_DB_PORT string
param ENC_UI_DB_SSL_CA string
param ENC_UI_DUO_API_HOSTNAME string
param ENC_UI_DUO_CLIENT_ID string
param ENC_UI_DUO_CLIENT_SECRET string
param ENC_UI_DUO_ENABLED string
param ENC_UI_DUO_FAILMODE string
param ENC_UI_DUO_REDIRECT_URL string
param ENC_UI_SECRET_KEY string
param ENC_UI_LOCAL_AUTH string
param ENC_API_AAD_CLIENT_ID string
param ENC_API_AAD_TENANT_ID string

// Reference to KeyVault
resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyvault_name
}

// Secret for MySQL Admin Password
resource secret1 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/MYSQL-ADMIN-PASSWORD'
  properties: {
    value: mysqladmin_password
  }
}

// Secret for 
resource secret2 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-UI-DB-TYPE'
  properties: {
    value: ENC_UI_DB_TYPE
  }
}

// Secret for 
resource secret3 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-UI-DB-USER'
  properties: {
    value: ENC_UI_DB_USER
  }
}

// Secret for 
resource secret4 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-UI-DB-PASS'
  properties: {
    value: ENC_UI_DB_PASS
  }
}

// Secret for 
resource secret5 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-UI-DB-NAME'
  properties: {
    value: ENC_UI_DB_NAME
  }
}

// Secret for 
resource secret6 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-UI-DB-PORT'
  properties: {
    value: ENC_UI_DB_PORT
  }
}

// Secret for 
resource secret7 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-UI-DB-SSL-CA'
  properties: {
    value: ENC_UI_DB_SSL_CA
  }
}

// Secret for 
resource secret8 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-UI-DUO-API-HOSTNAME'
  properties: {
    value: ENC_UI_DUO_API_HOSTNAME
  }
}

// Secret for 
resource secret9 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-UI-DUO-CLIENT-ID'
  properties: {
    value: ENC_UI_DUO_CLIENT_ID
  }
}

// Secret for 
resource secret10 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-UI-DUO-CLIENT-SECRET'
  properties: {
    value: ENC_UI_DUO_CLIENT_SECRET
  }
}

// Secret for 
resource secret11 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-UI-DUO-ENABLED'
  properties: {
    value: ENC_UI_DUO_ENABLED
  }
}

// Secret for 
resource secret12 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-UI-DUO-FAILMODE'
  properties: {
    value: ENC_UI_DUO_FAILMODE
  }
}

// Secret for 
resource secret13 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-UI-DUO-REDIRECT-URL'
  properties: {
    value: ENC_UI_DUO_REDIRECT_URL
  }
}

// Secret for 
resource secret14 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-UI-SECRET-KEY'
  properties: {
    value: ENC_UI_SECRET_KEY
  }
}

// Secret for 
resource secret15 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/MACBOOK-IP'
  properties: {
    value: MACBOOK_IP
  }
}
// Secret for 
resource secret16 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-UI-LOCAL-AUTH'
  properties: {
    value: ENC_UI_LOCAL_AUTH
  }
}
// Secret for 
resource secret17 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-API-AAD-CLIENT-ID'
  properties: {
    value: ENC_API_AAD_CLIENT_ID
  }
}
// Secret for 
resource secret18 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${keyvault.name}/ENC-API-AAD-TENANT-ID'
  properties: {
    value: ENC_API_AAD_TENANT_ID
  }
}
