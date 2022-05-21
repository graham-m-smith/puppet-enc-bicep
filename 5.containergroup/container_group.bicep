param location string = resourceGroup().location
param keyvault_name string
param keyvault_rg string
param container_name string
param image_tag string
param memory_gb int
param num_cpus int
param restart_policy string
param os_type string

param tag_values object = {
  Department: 'Infrastructure'
  Business_Unit: 'DTS'
  Environment: 'DEV'
  DeployMethod: 'Bicep'
  LastDeploy: utcNow('d')
  Project: 'Puppet-ENC'
}

// Reference to KeyVault
resource keyvault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyvault_name
  scope: resourceGroup(keyvault_rg)
}

// Create Container Group
module cg 'container_group_create.bicep' = {
  name: 'create-${container_name}'
  params: {
    location: location
    container_name: container_name
    image_tag: image_tag
    memory_gb: memory_gb
    restart_policy: restart_policy
    num_cpus: num_cpus
    common_role_name: 'COMMON'
    os_type: os_type
    tag_values: tag_values
    database_type: keyvault.getSecret('ENC-UI-DB-TYPE')
    db_name: keyvault.getSecret('ENC-UI-DB-NAME')
    db_user: keyvault.getSecret('ENC-UI-DB-USER')
    db_pass: keyvault.getSecret('ENC-UI-DB-PASS')
    db_host: keyvault.getSecret('ENC-UI-DB-HOST')
    db_ssl_ca: keyvault.getSecret('ENC-UI-DB-SSL-CA')
    reg_credential_password: keyvault.getSecret('CONTAINER-REG-PASS')
    reg_credential_username: keyvault.getSecret('CONTAINER-REG-USER')
    reg_credential_server: keyvault.getSecret('CONTAINER-REG-NAME')
    sa_connection_string: keyvault.getSecret('SA-CONNECTION-STRING')
  }
}
