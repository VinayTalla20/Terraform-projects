
resource "aws_subnet" "subnet_k8s" {
  vpc_id = var.subnet_vpc_id
  cidr_block = var.cidr_block_subnet[count.index]
  map_public_ip_on_launch = true
  count = length(var.cidr_block_subnet)
  availability_zone = var.availability_zone_subnetes[count.index]
  tags = {
    Name = "K8s-NODES-subnet-${count.index+1}"
  }
}