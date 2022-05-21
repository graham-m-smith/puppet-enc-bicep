
param location string = resourceGroup().location
param container_name string
param common_role_name string

@secure()
param sa_connection_string string

@secure()
param database_type string

@secure()
param db_name string

@secure()
param db_host string

@secure()
param db_user string

@secure()
param db_pass string

@secure()
param db_ssl_ca string

@secure()
param reg_credential_password string

@secure()
param reg_credential_server string

@secure()
param reg_credential_username string

param image_tag string
param restart_policy string
param os_type string
param num_cpus int
param memory_gb int
param tag_values object

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-03-01' = {
  name: 'cg-${container_name}'
  location: location
  properties: {
    sku: 'Standard'
    imageRegistryCredentials: [
      {
        username: reg_credential_username
        server: reg_credential_server
        password: reg_credential_password
      }
    ]
    containers: [
      {
        name: container_name
        properties: {
          image: '${reg_credential_server}/${container_name}:${image_tag}'
          ports: [
            {
              port: 80
            }
          ]
          environmentVariables: [
            {
              name: 'PUPPETENC_COMMON_ROLE_NAME'
              value: common_role_name
            }
            {
              name: 'PUPPETENC_SA_CONNECTION_STRING'
              secureValue: sa_connection_string
            }
            {
              name: 'PUPPETENC_DATABASE_TYPE'
              secureValue: database_type
            }
            {
              name: 'PUPPETENC_DB_NAME'
              secureValue: db_name
            }
            {
              name: 'PUPPETENC_DB_USER'
              secureValue: db_user
            }
            {
              name: 'PUPPETENC_DB_PASS'
              secureValue: db_pass
            }
            {
              name: 'PUPPETENC_DB_HOST'
              secureValue: db_host
            }
            {
              name: 'PUPPETENC_DB_SSL_CA'
              secureValue: db_ssl_ca
            }
          ]
          resources: {
            requests: {
              cpu: num_cpus
              memoryInGB: memory_gb
            }
          }
        }
      }
    ]
    restartPolicy: restart_policy
    osType: os_type
  }
  tags: tag_values
}
