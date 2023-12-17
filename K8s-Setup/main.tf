module "subnet_local" {
  source = "./Subnets"
  availability_zone_subnetes = var.availability_zone_subnetes
  cidr_block_subnet = var.cidr_block_subnet
  subnet_vpc_id = module.vpc_local.vpc_id
  depends_on = [ module.vpc_local ]
}

module "vpc_local" {
  source = "./VPC"
}

resource "aws_instance" "web" {
  depends_on = [ module.subnet_local ]
  ami           = "ami-0287a05f0ef0e9d9a"
  instance_type = "t3.small"
  tags = {
    Name = "AKS-NODES-${count.index+1}"
  }
  subnet_id = module.subnet_local.subnet_ids[count.index]
  # availability_zone = var.availability_zone_subnetes[count.index]
  count = length(module.subnet_local.subnet_ids)
  associate_public_ip_address = module.subnet_local.get_az_subnet[count.index] == "ap-south-1a" ? "true" : "false"
  user_data = <<-EOL
  #!/bin/sh -xe

  apt-get update 
  apt install git -y
  git clone https://github.com/VinayTalla20/Terraform-projects.git
  cd Terraform-projects/Terraform-aks
  chmod +x create_cluster.sh
  sh create_cluster.sh
  chmod +x bootstrap_cluster.sh
  sh bootstrap_cluster.sh
  EOL
}