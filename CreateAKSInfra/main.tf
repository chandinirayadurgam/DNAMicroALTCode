provider "azurerm" {
  features {}

  subscription_id = "c8d7d9db-892d-4c98-acf8-f78958f6e7fc"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "AKS-devops-resource-group"
  location = "Australia Central"
}

# Create a Virtual Network (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = "AKS-devops-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a Subnet for the VNet
resource "azurerm_subnet" "subnet" {
  name                 = "AKS-devops-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.1.0/24"]  # Update this to be within the VNet's address space
}

# Create an AKS cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "AKS-devops-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "devopsaks"

  # AKS requires a default node pool
  default_node_pool {
    name                = "system"
    node_count          = 1
    vm_size             = "Standard_D2s_v3"
    type                = "VirtualMachineScaleSets"
    vnet_subnet_id = azurerm_subnet.subnet.id
  }

  identity {
    type = "SystemAssigned"               # Managed identity for the AKS cluster
  }

  network_profile {
    network_plugin = "azure"               # Azure CNI plugin for advanced networking
  }

  tags = {
    environment = "dev"
  }
}

# Output the AKS cluster's kubeconfig file endpoint
output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_admin_config_raw
  sensitive = true
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}
