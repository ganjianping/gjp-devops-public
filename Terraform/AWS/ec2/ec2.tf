# AMI configurations for different OS types
locals {
  ami_config = {
    ubuntu = {
      owner  = "099720109477" # Canonical
      filter = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    }
    amazon-linux-2 = {
      owner  = "amazon"
      filter = "amzn2-ami-hvm-*-x86_64-gp2"
    }
    amazon-linux-2023 = {
      owner  = "amazon"
      filter = "al2023-ami-*-x86_64"
    }
    rhel = {
      owner  = "309956199498" # Red Hat
      filter = "RHEL-9.*_HVM-*-x86_64-*"
    }
    debian = {
      owner  = "136693071363" # Debian
      filter = "debian-12-amd64-*"
    }
    centos = {
      owner  = "125523088429" # CentOS
      filter = "CentOS Stream 9 x86_64*"
    }
    windows-2022 = {
      owner  = "amazon"
      filter = "Windows_Server-2022-English-Full-Base-*"
    }
    windows-2019 = {
      owner  = "amazon"
      filter = "Windows_Server-2019-English-Full-Base-*"
    }
  }
}

# Data source for AMI based on selected OS type
data "aws_ami" "selected" {
  most_recent = true
  owners      = [local.ami_config[var.os_type].owner]

  filter {
    name   = "name"
    values = [local.ami_config[var.os_type].filter]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source for default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Security group for EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  # Dynamic ingress rules for configurable TCP ports
  dynamic "ingress" {
    for_each = var.ec2_open_tcp_ports
    content {
      description = "TCP port ${ingress.value} from anywhere"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # All outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-security-group"
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.selected.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  
  # Ensure public IP is assigned
  associate_public_ip_address = true

  tags = {
    Name = "terraform-ec2-instance"
  }
}
