data "azurerm_resource_group" "rg-name" {
  name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "terraform_k8s" {
  name                = var.cluster_name
  kubernetes_version  = var.k8s_version
  location            = data.azurerm_resource_group.rg-name.location
  dns_prefix          = var.dns_prefix
  resource_group_name = data.azurerm_resource_group.rg-name.name
  tags = {
    "cluster" = "terraform-test"

  }
  default_node_pool {
    name       = var.pool_name
    vm_size    = var.node_sizes
    node_count = var.node_count
  }
  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
}

module "nodepool" {
  source = "../NodePools"
  cluster_id = azurerm_kubernetes_cluster.terraform_k8s.id
  rg-name = ""
}
