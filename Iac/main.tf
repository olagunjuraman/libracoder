resource "azurerm_resource_group" "assessment" {
  name     = "assessment-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "assessment" {
  name                     = "assessmentstoracc456"
  resource_group_name      = azurerm_resource_group.assessment.name
  location                 = azurerm_resource_group.assessment.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "assessment" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.assessment.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "assessment" {
  name                   = "my-awesome-content.zip"
  storage_account_name   = azurerm_storage_account.assessment.name
  storage_container_name = azurerm_storage_container.assessment.name
  type                   = "Block"
  # source               = "some-local-file.zip"
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = "aksVnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.assessment.location
  resource_group_name = azurerm_resource_group.assessment.name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aksSubnet"
  resource_group_name  = azurerm_resource_group.assessment.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.240.0.0/16"]
}

# resource "azurerm_subnet" "sql_subnet" {
#   name                 = "sqlSubnet"
#   resource_group_name  = azurerm_resource_group.assessment.name
#   virtual_network_name = azurerm_virtual_network.aks_vnet.name
#   address_prefixes     = ["10.240.1.0/24"]
#   service_endpoints    = ["Microsoft.Sql"]
# }

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "myAksCluster"
  location            = azurerm_resource_group.assessment.location
  resource_group_name = azurerm_resource_group.assessment.name
  dns_prefix          = "akscluster"

  default_node_pool {
    name           = "default"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.10.0.0/16"
    dns_service_ip = "10.10.0.10"
  }
}

# resource "azurerm_mssql_server" "assessment" {
#   name                         = "example-sqlserver"
#   resource_group_name          = azurerm_resource_group.assessment.name
#   location                     = azurerm_resource_group.assessment.location
#   version                      = "12.0"
#   administrator_login          = "4dm1n157r470r"
#   administrator_login_password = "4-v3ry-53cr37-p455w0rd"

#   identity {
#     type = "SystemAssigned"
#   }
# }

# resource "azurerm_mssql_database" "assessment" {
#   name            = "assessment-sqldatabase"
#   server_id       = azurerm_mssql_server.assessment.id
#   sku_name        = "GP_S_Gen5_2"

#   tags = {
#     environment = "production"
#   }

#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "azurerm_mssql_virtual_network_rule" "assessment" {
#   name       = "assessment-sql-vnet-rule"
#   server_id  = azurerm_mssql_server.assessment.id  
#   subnet_id  = azurerm_subnet.sql_subnet.id
# }