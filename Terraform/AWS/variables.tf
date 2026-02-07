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

# EC2 Variables
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
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
