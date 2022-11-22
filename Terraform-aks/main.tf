#  creation of azure Resource-Group
resource "azurerm_resource_group" "rg_name" {
    name = "terraform-rg"
    location = "eastus"
  
}


#  Creation of Azure Managed Kubernetes Cluster

resource "azurerm_kubernetes_cluster" "terraform_k8s_test" {
     name = "terraform-cluster"
     kubernetes_version = "1.23"
     location = "eastus"
     dns_prefix = "k8s-tf"
     resource_group_name = "terraform-rg"
     #node_resource_group = "MC_terraform-rg_terraform-cluster-test_eastus"
     tags = {
       "cluster" = "terraform"
    
     }
     default_node_pool {
       name = "tfpooltest"
       vm_size    = "Standard_D2_v2"
       node_count = 2   
     }
     service_principal {
        client_id = var.client_id
        client_secret = var.client_secret
     }
}

