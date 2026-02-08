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

variable "create_ec2" {
  description = "Whether to create EC2 instance and security group"
  type        = bool
  default     = true
}

variable "create_s3" {
  description = "Whether to create S3 bucket"
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

# EC2 Variables
variable "vpc_id" {
  description = "VPC ID where the instance will be launched (leave empty for default VPC)"
  type        = string
  default     = ""
}
variable "subnet_id" {
  description = "Subnet ID where the instance will be launched (leave empty for default subnet)"
  type        = string
  default     = ""
}
variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "gjpb-ec2-instance"
}

variable "os_type" {
  description = "Operating system type for EC2 instance"
  type        = string
  default     = "ubuntu"
  
  validation {
    condition     = contains(["ubuntu", "amazon-linux-2", "amazon-linux-2023", "rhel", "debian", "centos", "windows-2022", "windows-2019"], var.os_type)
    error_message = "OS type must be one of: ubuntu, amazon-linux-2, amazon-linux-2023, rhel, debian, centos, windows-2022, windows-2019"
  }
}
variable "ami_id" {
  description = "AMI ID for the EC2 instance (Amazon Linux 2023 in us-east-1)"
  type        = string
  default     = "" 
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = ""
}
variable "public_key_path" {
  description = "Path to your SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
variable "enable_public_ip" {
  description = "Associate a public IP address with the instance"
  type        = bool
  default     = true
}
variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH to the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 20
}
variable "root_volume_type" {
  description = "Type of the root EBS volume"
  type        = string
  default     = "gp3"
}
variable "ec2_open_tcp_ports" {
  description = "List of TCP ports to allow from anywhere (0.0.0.0/0)"
  type        = list(number)
  default     = [22, 80]
}

# S3 Variables
variable "s3_bucket_name" {
  description = "S3 bucket name (must be globally unique)"
  type        = string
  default     = "gjpb-bucket"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.s3_bucket_name))
    error_message = "S3 bucket name must be 3-63 characters, lowercase letters, numbers, hyphens, and periods only"
  }
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = false
}

variable "enable_encryption" {
  description = "Enable S3 bucket server-side encryption"
  type        = bool
  default     = true
}

variable "block_public_access" {
  description = "Block all public access to the S3 bucket"
  type        = bool
  default     = true
}
