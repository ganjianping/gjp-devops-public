variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "default"
}
variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-southeast-1"
}
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}
variable "vpc_id" {
  description = "VPC ID where the instance will be launched (leave empty for default VPC)"
  type        = string
}
variable "subnet_id" {
  description = "Subnet ID where the instance will be launched (leave empty for default subnet)"
  type        = string
}
variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "os_type" {
  description = "Operating system type for EC2 instance"
  type        = string
}
variable "ami_id" {
  description = "AMI ID for the EC2 instance (Amazon Linux 2023 in us-east-1)"
  type        = string
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}
variable "public_key_path" {
  description = "Path to your SSH public key"
  type        = string
}
variable "enable_public_ip" {
  description = "Associate a public IP address with the instance"
  type        = bool
}
variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH to the instance"
  type        = list(string)
}
variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
}
variable "root_volume_type" {
  description = "Type of the root EBS volume"
  type        = string
}
variable "ec2_open_tcp_ports" {
  description = "List of TCP ports to allow from anywhere (0.0.0.0/0)"
  type        = list(number)
}

variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
}

