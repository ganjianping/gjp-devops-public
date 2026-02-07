# AWS Terraform Projects

This directory contains modular Terraform configurations for AWS infrastructure.

## Project Structure

```
.
├── providers.tf           # AWS provider configuration
├── variables.tf           # All variable definitions
├── main.tf               # Module calls
├── outputs.tf            # All outputs
├── terraform.tfvars      # Variable values
├── README.md             # This file
├── ec2/                  # EC2 module
│   ├── variables.tf
│   ├── ec2.tf
│   ├── outputs.tf
│   └── README.md
└── s3/                   # S3 module
    ├── variables.tf
    ├── s3.tf
    ├── outputs.tf
    └── README.md
```

**NQuick Start

Run all commands from the AWS directory:

```bash
# Initialize Terraform
terraform init

# Plan infrastructure
terraform plan

# Apply configuration
terraform apply

# Destroy infrastructure
terraform destro
terraform plan
terraform apply
```

## Usage Examples

### EC2 Examples

```bash
cd ec2

# UbCreate Both EC2 and S3 (Default)

```bash
terraform apply
```

### Create Only EC2

```bash
terraform apply -var="create_s3=false"
```

### Create Only S3

```bash
terraform apply -var="create_ec2=false"
```

### EC2 with Different OS and Ports

```bash
# Ubuntu web server
terraform apply -var="create_s3=false" -var="os_type=ubuntu" -var="ec2_open_tcp_ports=[22,80,443]"

# Amazon Linux 2023 with larger instance
terraform apply -var="create_s3=false" -var="os_type=amazon-linux-2023" -var="instance_type=t3.small"

# Windows Server with RDP
terraform apply -var="create_s3=false" -var="os_type=windows-2022" -var="instance_type=t3.medium" -var="ec2_open_tcp_ports=[3389,80,443]"

# Development environment
terraform apply -var="create_s3=false" -var="ec2_open_tcp_ports=[22,80,443,3000,8080]"
```

### S3 with Custom Configuration

```bash
# Basic bucket with custom name
terraform apply -var="create_ec2=false" -var="s3_bucket_name=my-unique-bucket-2026"

# Versioned and encrypted bucket
terraform apply -var="create_ec2=false" -var="s3_bucket_name=my-backup-bucket" -var="enable_versioning=true"

# Public bucket (for static website)
terraform apply -var="create_ec2=false" -var="s3_bucket_name=my-website-bucket" -var="block_public_access=false"
```

### Edit terraform.tfvars for Persistent Configuration

```hcl
create_ec2 = true
create_s3  = false

instance_type      = "t3.small"
os_type            = "amazon-linux-2023"
ec2_open_tcp_ports = [22, 80, 443]
```

Then simply run:
```bash
terraform apply
|---------|-------------|
| `ubuntu` | Ubuntu 22.04 LTS (default) |
| `amazon-linux-2` | Amazon Linux 2 |
| `amazon-linux-2023` | Amazon Linux 2023 |
| `rhel` | Red Hat Enterprise Linux 9 |
| `debian` | Debian 12 |
| `centos` | CentOS Stream 9 |
| `windows-2022` | Windows Server 2022 |
| `windows-2019` | Windows Server 2019 |

## Common Port Configurations (EC2)

```hcl
# Web server
ec2_open_tcp_ports = [22, 80, 443]

# Development
ec2_open_tcp_ports = [22, 80, 443, 3000, 8080]
Configuration Variables

Edit [terraform.tfvars](terraform.tfvars) to customize your infrastructure:

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `create_ec2` | bool | `true` | Create EC2 instance |
| `create_s3` | bool | `true` | Create S3 bucket |
| `instance_type` | string | `t2.micro` | EC2 instance type |
| `os_type` | string | `ubuntu` | Operating system |
| `ec2_open_tcp_ports` | list(number) | `[22, 80]` | Open TCP ports |
| `s3_bucket_name` | string | `gjpb-bucket` | S3 bucket name |
| `enable_versioning` | bool | `false` | Enable S3 versioning |
| `enable_encryption` | bool | `true` | Enable S3 encryption |
| `block_public_access` | bool | `true` | Block S3 public access |

## Outputs

After `terraform apply`, view outputs:

```bash
terraform output
terraform output ec2_public_ip
terraform output s3_bucket_name
```

### Available Outputs
- `ec2_public_ip` - EC2 public IP address
- `ec2_instance_id` - EC2 instance ID
- `ec2_ami_id` - AMI ID used
- `ec2_security_group_id` - Security group ID
- `s3_bucket_name` - S3 bucket name
- `s3_bucket_arn` - S3 bucket ARN
- `s3_bucket_region` - S3 bucket region
- `s3_bucket_domain_name` - S3 bucket domain names3_bucket_region` - Bucket region
- `s3_bucket_domain_name` - Bucket domain namedebian` - Debian 12
- `centos` - CentOS Stream 9
- `windows-2022` - Windows Server 2022
- `windows-2019` - Windows Server 2019

### Common Port Configurations

Configure `ec2_open_tcp_ports` in ec2.tfvars:
```hcl
# Web server (Linux)
ec2_open_tcp_ports = [22, 80, 443]

# Development environment
ec2_open_tcp_ports = [22, 80, 443, 3000, 8080]

# Windows Server with RDP
ec2_open_tcp_ports = [3389, 80, 443]

# Database server (restrict other ports separately)
ec2_open_tcp_ports = [22, 3306]  # MySQL
ec2_open_tcp_ports = [22, 5432]  # PostgreSQL

# Locked down (no inbound, outbound only)
ec2_open_tcp_ports = []
```
