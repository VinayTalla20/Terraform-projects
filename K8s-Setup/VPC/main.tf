resource "aws_vpc" "vpc_k8s" {
  instance_tenancy = "default"
  cidr_block = var.vpc_cidr_range
  tags = {
    Usage = "AKS-NODES"
  }
}