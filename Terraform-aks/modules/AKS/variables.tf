variable "resource_group_name" {
  type = string
  #default = "terraform-rg"
  description = "Name of the Resource Group to Use for Cluster Creation"
}
variable "cluster_name" {
  type        = string
  description = "Name of the Cluster"
  default     = "k8s"
}

variable "k8s_version" {
  type        = number
  default     = 1.23
  description = "Kubernetes Version to Create"
}

variable "dns_prefix" {
  type        = string
  default     = "k8stest"
  description = "DNS prefix for API-Server"
}


variable "node_count" {
  type        = number
  default     = 3
  description = "Number of Nodes to create in Node Pool"
}

variable "pool_name" {
  type        = string
  default     = "userpool"
  description = "Name for pool to be given "
}

variable "node_sizes" {
  type        = string
  default     = "Standard_D2_v2"
  description = "Sizes of Cluster Nodes to Create"
}




# Below Variables are for Authentication 

variable "client_id" {
  type        = string
  description = "client id or azure app id"
}

variable "client_secret" {
  type        = string
  description = "client secret of client id"
  sensitive   = true
}

variable "tenant_id" {
  type        = string
  description = "tenant_id for azure active directory"
}

variable "subscription_id" {
  type        = string
  description = "subcription needed to create resources"
}
