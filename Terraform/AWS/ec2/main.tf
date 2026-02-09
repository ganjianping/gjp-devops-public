# AMI configurations for different OS types
locals {
  ami_config = {
    ubuntu = {
      # owner  = "679593333241" # aws-marketplace
      # filter = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
      owner  = "099720109477" # Canonical
      filter = "ubuntu-pro-server/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-pro-server-*"
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

# Data source to get default VPC if not specified
data "aws_vpc" "default" {
  count   = var.vpc_id == "" ? 1 : 0
  default = true
}

# Data source to get default subnet if not specified
data "aws_subnets" "default" {
  count = var.subnet_id == "" ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default[0].id]
  }
}

resource "aws_key_pair" "main" {
    key_name = "${var.instance_name}-${var.environment}" 
    public_key = file(var.public_key_path)
}

# Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "${var.instance_name}-${var.environment}-sg"
  description = "Allow SSH from anywhere"
  vpc_id      = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default[0].id

  # SSH access
  ingress {
    description = "SSH from allowed CIDR blocks"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

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

  tags = merge(
    {
      Name = "${var.instance_name}-${var.environment}-sg"
    },
    var.additional_tags
  )
}

# EC2 Instance
resource "aws_instance" "app_server" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.selected.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id != "" ? var.subnet_id : data.aws_subnets.default[0].ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name != "" ? var.key_name : aws_key_pair.main.key_name 
  associate_public_ip_address = var.enable_public_ip
  root_block_device {
    volume_size           = var.root_volume_size    
    volume_type           = var.root_volume_type    
    delete_on_termination = true
    encrypted             = true
    tags = merge(
      {
        Name = "${var.instance_name}-${var.environment}-root-volume"
      },
      var.additional_tags
    )
  }
  tags = merge(
    {
      Name = "${var.instance_name}-${var.environment}"
      Environment = "${var.environment}"
    },
    var.additional_tags
  )
}
