resource "aws_vpc" "my-vpc" {
  cidr_block           = "172.32.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Dev_VPC"
  }

}

resource "aws_subnet" "my-subnet" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "172.32.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "Dev_Pubilc_Subnet"
  }

}



resource "aws_internet_gateway" "my-internet_gateway" {

  vpc_id = aws_vpc.my-vpc.id
  tags = {
    "Name" = "Dev-Internet_Gateway"
  }

}

resource "aws_route_table" "my-route_table" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    "Name" = "Dev-Route_Table"
  }
}


resource "aws_route" "my-route" {
  route_table_id         = aws_route_table.my-route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my-internet_gateway.id

}

resource "aws_route_table_association" "my-route-table-association" {
  subnet_id      = aws_subnet.my-subnet.id
  route_table_id = aws_route_table.my-route_table.id

}

resource "aws_security_group" "my-security_group" {
  name        = "Dev-Security-Group"
  vpc_id      = aws_vpc.my-vpc.id
  description = "for Dev environment"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

  }
  tags = {
    "Name" = "Dev-Security-Group"
  }

}

resource "aws_key_pair" "my-key_pair" {
  key_name   = "vinay"
  public_key = file("~/.ssh/vinay_aws.pub")

}

resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.ubuntu-ami.id
  key_name               = aws_key_pair.my-key_pair.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my-security_group.id]
  subnet_id              = aws_subnet.my-subnet.id
  user_data              = file("userdata.tpl")

  tags = {
    "Name" = "Terraform-ubuntu"
  }

  root_block_device {
    volume_size = 10
  }

  provisioner "local-exec" {

    command = templatefile("windows_ssh_config.tpl", {
      host         = "{var.host}",
      hostname     = self.public_ip,
      user         = "ubuntu",
      identityfile = "~/.ssh/vinay_aws"
    })
    interpreter = ["PowerShell", "-Command"]

  }


}