output "cluster_name" {
  depends_on = [
    azurerm_kubernetes_cluster.terraform_k8s
  ]
  description = "name of kubernetes cluster"
  value       = azurerm_kubernetes_cluster.terraform_k8s.name
}

output "cluster_id" {
    value = azurerm_kubernetes_cluster.terraform_k8s.id
    depends_on = [
      azurerm_kubernetes_cluster.terraform_k8s
    ]
    description = "cluster id, incase when you need to add Node Pools to the cluster"
}

output "k8s_version" {
  value = azurerm_kubernetes_cluster.terraform_k8s.kubernetes_version
  depends_on = [
    azurerm_kubernetes_cluster.terraform_k8s
  ]
}

output "node_resource_group" {
  value       = azurerm_kubernetes_cluster.terraform_k8s.node_resource_group
  description = "Resource Group of Cluster Nodes"
  depends_on = [
    azurerm_kubernetes_cluster.terraform_k8s
  ]
}

output "cluster_location" {
  value       = azurerm_kubernetes_cluster.terraform_k8s.location
  description = "Location of Kubernetes Cluster"
  depends_on = [
    azurerm_kubernetes_cluster.terraform_k8s
  ]

}


output "k8s_resource_group_name" {
  depends_on = [
    azurerm_kubernetes_cluster.terraform_k8s
  ]
  description = "Resource Group to assign Public Static IP Address for Ingress Controller"
  value       = azurerm_kubernetes_cluster.terraform_k8s.resource_group_name
}
