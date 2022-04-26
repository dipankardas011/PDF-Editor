variable "access_key" {
  description = "Enter your AWS Access Key: "
  type = string
}

variable "secret_key" {
  description = "Enter your AWS Secret Key: "
  type = string
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

# vpc
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "pdf-editor-vpc"
  }
}

# internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "pdf-editor-gateway"
  }
}

# route table
resource "aws_route_table" "prod-rt" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0" # any ip can access
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "pdf-editor-rt"
  }
}

# subnets
resource "aws_subnet" "prod-subnet" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "pdf-editor-subnet"
  }
}

# join subnets and route table by association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.prod-subnet.id
  route_table_id = aws_route_table.prod-rt.id
}

variable "client-ip-access" {
  description = "ip address for the client to access the host"
  type = map(string)
}

variable "accessPort" {
  type = number
}
# security
resource "aws_security_group" "allow_http" {
  name        = "allow-web-traffic"
  description = "Network traffic allowed"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description      = "HTTPS from pdf-editor"
    from_port        = var.accessPort
    to_port          = var.accessPort
    protocol         = "tcp"
    cidr_blocks      = [var.client-ip-access.https]
  }

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.client-ip-access.ssh]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pdf-editor-security"
  }
}

# elastic ip
# It's recommended to denote that the AWS Instance or Elastic IP depends on the Internet Gateway. For example:
resource "aws_eip" "bar" {
  vpc = true

  associate_with_private_ip = "10.0.1.50"
  network_interface = aws_network_interface.prod-nic.id
  depends_on                = [aws_internet_gateway.gw]

  tags = {
    "Name" = "pdf-editor-eip"
  }
}

# network interface
resource "aws_network_interface" "prod-nic" {
  subnet_id       = aws_subnet.prod-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_http.id]

  tags = {
    "Name" = "pdf-editor-nic"
  }
}

# ec2
resource "aws_instance" "prod-ec2" {
  ami           = "ami-04505e74c0741db8d" 
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"

  network_interface {
    network_interface_id = aws_network_interface.prod-nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "pdf-editor-ec2"
  }

  key_name = "terraform-access-ec2"

  user_data = <<-EOF
    #!/bin/bash
    cd /home/ubuntu

    sudo wget https://github.com/dipankardas011/PDF-Editor/raw/main/EC2.sh
    
    sudo chmod 700 EC2.sh

    sudo nohup ./EC2.sh &

    EOF
}

output "server_public_ip" {
  value = aws_eip.bar.public_ip
}