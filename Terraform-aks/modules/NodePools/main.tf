resource "azurerm_kubernetes_cluster_node_pool" "node-pool" {
  kubernetes_cluster_id = var.cluster_id
  #scale_down_mode       = "manual"
  os_type               = "Linux"
  orchestrator_version  = 1.23
  name                  = "manpool"
  node_count            = 1
  node_labels = {
    "Type" = "fast"
  }
  vm_size = "Standard_D2_v3"
  mode    = "User"


}
