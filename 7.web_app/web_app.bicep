param wa_name string = 'app-puppetenc-gmsdev'
param location string = 'uksouth'
param keyvault_name string = 'kv-puppetenc'
param mysqldb_name string = 'mysqldb-puppetenc-gmsdev'

// Reference to KeyVault
resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyvault_name
}

module webapp 'web_app_create.bicep' = {
  name: wa_name
  params: {
    location: location
    enc_database_type: keyvault.getSecret('ENC-UI-DB-TYPE')
    enc_db_name: keyvault.getSecret('ENC-UI-DB-NAME')
    enc_db_pass: keyvault.getSecret('ENC-UI-DB-PASS')
    enc_db_port: keyvault.getSecret('ENC-UI-DB-PORT')
    enc_db_ssl_ca: keyvault.getSecret('ENC-UI-DB-SSL-CA')
    enc_db_user: keyvault.getSecret('ENC-UI-DB-USER')
    enc_duo_api_hostname: keyvault.getSecret('ENC-UI-DUO-API-HOSTNAME')
    enc_duo_client_id: keyvault.getSecret('ENC-UI-DUO-CLIENT-ID')
    enc_duo_client_secret: keyvault.getSecret('ENC-UI-DUO-CLIENT-SECRET')
    enc_duo_enabled: keyvault.getSecret('ENC-UI-DUO-ENABLED')
    enc_duo_failmode: keyvault.getSecret('ENC-UI-DUO-FAILMODE')
    enc_duo_redirect_url: keyvault.getSecret('ENC-UI-DUO-REDIRECT-URL')
    enc_secret_key: keyvault.getSecret('ENC-UI-SECRET-KEY')
    keyvault_name: keyvault_name
    mysqldb_name: mysqldb_name
    wa_name: wa_name
  }
}
