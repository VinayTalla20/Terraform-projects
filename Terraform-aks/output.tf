output "cluster_name" {
  depends_on = [
    azurerm_kubernetes_cluster.terraform_k8s
  ]
  description = "name of kubernetes cluster"
  value = azurerm_kubernetes_cluster.terraform_k8s.name
}

output "resource_group_name" {
    depends_on = [
      azurerm_kubernetes_cluster.terraform_k8s
    ]
    description = "To get resource_group for public Static IP Address for Ingress Controller"
    value = azurerm_kubernetes_cluster.terraform_k8s.resource_group_name
}
