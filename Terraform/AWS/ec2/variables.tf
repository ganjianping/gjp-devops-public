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
