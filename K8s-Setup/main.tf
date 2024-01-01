module "subnet_local" {
  source                     = "./Subnets"
  availability_zone_subnetes = var.availability_zone_subnetes
  cidr_block_subnet          = var.cidr_block_subnet
  subnet_vpc_id              = module.vpc_local.vpc_id
  depends_on                 = [module.vpc_local]
}

module "vpc_local" {
  source = "./VPC"
}

resource "aws_instance" "web" {
  depends_on    = [module.subnet_local, data.aws_key_pair.instances_key_pair]
  ami           = "ami-0287a05f0ef0e9d9a"
  instance_type = "t3.small"
  key_name      = data.aws_key_pair.instances_key_pair.key_name
  tags = {
    Name = "AKS-NODES-${count.index + 1}"
  }
  subnet_id = module.subnet_local.subnet_ids[count.index]
  # availability_zone = var.availability_zone_subnetes[count.index]
  count                       = length(module.subnet_local.subnet_ids)
  associate_public_ip_address = module.subnet_local.get_az_subnet[count.index] == "ap-south-1a" ? "true" : "false"
  user_data                   = <<-EOL
  #!/bin/sh -xe

  apt-get update 
  apt install git -y
  git clone https://github.com/VinayTalla20/Terraform-projects.git
  cd Terraform-projects/Terraform-aks
  chmod +x create_cluster.sh
  sh create_cluster.sh
  apt install ipvsadm -y
  chmod +x bootstrap_cluster.sh
  sh bootstrap_cluster.sh

  EOL
}


resource "aws_eip" "nat_el_ip" {
  tags = {
    "for" = "nat-gateway"
  }
}

data "aws_subnet" "public_subnet_nat" {
  availability_zone = "ap-south-1a"
  vpc_id            = module.vpc_local.vpc_id
  depends_on        = [module.subnet_local]
}

data "aws_subnet" "private_subnet_nat-1b" {
  depends_on = [ module.subnet_local ]
  filter {
    name   = "availabilityZone"
    values = ["ap-south-1b"]
  }
}

data "aws_subnet" "private_subnet_nat-1c" {

  depends_on = [ module.subnet_local ]
  filter {
    name   = "availabilityZone"
    values = ["ap-south-1c"]
  }
}

resource "aws_nat_gateway" "ig_nat" {
  depends_on        = [aws_eip.nat_el_ip]
  connectivity_type = "public"
  subnet_id         = data.aws_subnet.public_subnet_nat.id
  tags = {
    "private-connectivity" : "nat"
  }
  allocation_id = aws_eip.nat_el_ip.allocation_id

}

resource "aws_route_table" "public-route-table" {
  depends_on = [module.vpc_local, module.subnet_local]
  vpc_id     = module.vpc_local.vpc_id
  tags = {
    "public-route" = "true"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.get_igw_id.internet_gateway_id
  }

}

resource "aws_route_table_association" "public_subnet_assoication" {
  depends_on     = [module.vpc_local, module.subnet_local, data.aws_subnet.public_subnet_nat]
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = data.aws_subnet.public_subnet_nat.id
}



resource "aws_route_table" "pvt-route-table" {
  depends_on = [aws_nat_gateway.ig_nat]
  vpc_id     = module.vpc_local.vpc_id
  tags = {
    "private-route" = "true"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ig_nat.id
  }
}

# resource "aws_route_table_association" "private_subnet_assoication" {
#   subnet_id      = data.aws_subnets.private_subnet_nat.ids[count.index]
#   route_table_id = aws_route_table.pvt-route-table.id
#   depends_on     = [aws_route_table.pvt-route-table]
#   count          = length(data.aws_subnets.private_subnet_nat.ids)
# }

resource "aws_route_table_association" "pvt-subnet-1b" {
  route_table_id = aws_route_table.pvt-route-table.id
  depends_on     = [aws_route_table.pvt-route-table]
  subnet_id      = data.aws_subnet.private_subnet_nat-1b.id
}

resource "aws_route_table_association" "pvt-subnet-1c" {
  route_table_id = aws_route_table.pvt-route-table.id
  depends_on     = [aws_route_table.pvt-route-table]
  subnet_id      = data.aws_subnet.private_subnet_nat-1c.id
}



data "aws_security_group" "public_sg" {
  depends_on = [aws_instance.web]
  vpc_id     = module.vpc_local.vpc_id
}

resource "aws_security_group_rule" "added_internet_inbount_sg" {
  depends_on        = [data.aws_security_group.public_sg]
  security_group_id = data.aws_security_group.public_sg.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "-1"
  to_port           = "0"
  from_port         = "0"
}


data "aws_key_pair" "instances_key_pair" {
  depends_on = [module.subnet_local]
  key_name   = "first-key"
}



data "aws_internet_gateway" "get_igw_id" {
  tags = {
    "Learning" = "Terraform"
  }
}

module "route_table_module" {
  source        = "./Route-Tables"
  depends_on    = [module.vpc_local]
  vpc_id_for_rt = module.vpc_local.vpc_id
}



resource "aws_internet_gateway_attachment" "vpc_attach_igw" {
  vpc_id              = module.vpc_local.vpc_id
  internet_gateway_id = data.aws_internet_gateway.get_igw_id.id
  depends_on          = [data.aws_internet_gateway.get_igw_id]
}
