terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.39"
    }
  }

  required_version = ">= 1.3"
}

provider "azurerm" {
  features {}

  subscription_id = "c8d7d9db-892d-4c98-acf8-f78958f6e7fc"
}

# Reference the existing resources for deletion
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "AKS-devops-cluster"
  resource_group_name = "AKS-devops-resource-group"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "AKS-devops-vnet"
  resource_group_name = "AKS-devops-resource-group"
}

resource "azurerm_resource_group" "rg" {
  name = "AKS-devops-resource-group"
}
