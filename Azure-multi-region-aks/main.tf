locals {
  node_pool_defaults = {
    vm_size      = var.vm_size
    os_disk_size_gb = 30
    vnet_subnet_id  = azurerm_subnet.k8s_subnet.id
  }
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.locations[0]
}

resource "azurerm_virtual_network" "this" {
  name                = "k8s_vnet"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "k8s_subnet" {
  name                 = "k8s_subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.1.0.0/16"]
}

module "kubernetes" {
  source = "Azure/aks/azurerm"
  version = "~> 4.0"

  name                = var.cluster_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  dns_prefix          = var.cluster_name

  node_pools = {
    default = {
      node_count = var.node_count
    }
  }

  default_node_pool = merge(local.node_pool_defaults, {
    name = "default"
  })

  additional_node_pools = [
    for location in slice(var.locations, 1, length(var.locations)) :
    merge(local.node_pool_defaults, {
      name      = "aks-${location}"
      location  = location
      node_count = var.node_count
    })
  ]

  tags = {
    Terraform = "true"
  }
}
