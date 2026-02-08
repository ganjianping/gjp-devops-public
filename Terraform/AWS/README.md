# AWS Terraform Projects

This directory contains modular Terraform configurations for AWS infrastructure with support for EC2 instances and S3 buckets.

## Features

### EC2 Module
- ✅ Multiple OS support (Ubuntu, Amazon Linux, RHEL, Debian, CentOS, Windows)
- ✅ Latest AMI via data source (region-agnostic)
- ✅ Custom or default VPC/subnet support
- ✅ Configurable security groups with SSH restrictions
- ✅ SSH key pair integration
- ✅ EBS volume configuration (encrypted by default)
- ✅ Public/private IP options
- ✅ Environment tagging

### S3 Module
- ✅ S3 bucket creation with versioning
- ✅ Server-side encryption (AES256)
- ✅ Public access controls
- ✅ Bucket name validation

## Project Structure

```
.
├── providers.tf           # AWS provider configuration
├── variables.tf           # All variable definitions
├── main.tf               # Module calls
├── outputs.tf            # All outputs
├── terraform.tfvars      # Variable values (user-specific)
├── 1-init.sh             # Terraform init script
├── 2-apply.sh            # Terraform apply script
├── 3-destroy.sh          # Terraform destroy script
├── 9-output.sh           # Terraform output script
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

## Prerequisites

- Terraform >= 1.10
- AWS CLI configured with credentials in `~/.aws/credentials`
- AWS region configured in `~/.aws/config`
- (Optional) SSH key pair for EC2 access

## Quick Start

Run all commands from the AWS directory:

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan infrastructure
terraform plan

# Apply configuration
terraform apply

# View outputs
terraform output

# Destroy infrastructure
terraform destroy
```

## SSH Key Setup (Optional)

If you want SSH access to EC2 instances:

```bash
# 1. Create or import a key pair in AWS Console
#    EC2 → Network & Security → Key Pairs

# 2. Download the .pem file to ~/.ssh/
#    Example: ~/.ssh/my-ec2-key.pem

# 3. Set proper permissions
chmod 400 ~/.ssh/my-ec2-key.pem

# 4. Update terraform.tfvars
key_name = "my-ec2-key"  # Name without .pem extension
```

## Usage Examples

### Create Both EC2 and S3 (Default)

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

### EC2 with Custom Configuration

```bash
# Ubuntu web server with SSH key
terraform apply -var="create_s3=false" -var="os_type=ubuntu" -var="instance_type=t3.small" -var="key_name=my-ec2-key" -var="ec2_open_tcp_ports=[80,443]"

# Amazon Linux 2023 with restricted SSH access
terraform apply -var="create_s3=false" -var="os_type=amazon-linux-2023" -var='allowed_ssh_cidr=["203.0.113.0/24"]'

# Windows Server with RDP
terraform apply -var="create_s3=false" -var="os_type=windows-2022" -var="instance_type=t3.medium" -var="ec2_open_tcp_ports=[3389,80,443]"

# Custom VPC and subnet
terraform apply -var="create_s3=false" -var="vpc_id=vpc-xxxxx" -var="subnet_id=subnet-xxxxx"

# Larger EBS volume
terraform apply -var="create_s3=false" -var="root_volume_size=50" -var="root_volume_type=gp3"
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

Edit `terraform.tfvars`:

```hcl
create_ec2 = true
create_s3  = false

# AWS Configuration
environment = "production"

# EC2 Configuration
instance_name = "my-web-server"
instance_type = "t3.small"
os_type = "amazon-linux-2023"
key_name = "my-ec2-key"
allowed_ssh_cidr = ["203.0.113.0/24"]  # Your office IP
ec2_open_tcp_ports = [80, 443]
root_volume_size = 30

# Additional Tags
additional_tags = {
  Project = "MyProject"
  Team    = "DevOps"
}
```

Then simply run:
```bash
terraform apply
```

## Configuration Variables

Edit [terraform.tfvars](terraform.tfvars) to customize your infrastructure:

### Feature Flags
| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `create_ec2` | bool | `true` | Create EC2 instance |
| `create_s3` | bool | `true` | Create S3 bucket |

### AWS Configuration
| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `aws_profile` | string | `default` | AWS CLI profile to use |
| `environment` | string | `dev` | Environment name (dev/staging/prod) |
| `additional_tags` | map(string) | `{}` | Additional tags for all resources |

### EC2 Configuration
| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `vpc_id` | string | `""` | VPC ID (empty = default VPC) |
| `subnet_id` | string | `""` | Subnet ID (empty = default subnet) |
| `instance_name` | string | `gjpb-ec2-instance` | Name tag for EC2 instance |
| `instance_type` | string | `t2.micro` | EC2 instance type |
| `os_type` | string | `ubuntu` | Operating system type |
| `ami_id` | string | `""` | Specific AMI ID (empty = auto-select) |
| `key_name` | string | `""` | SSH key pair name |

#### EC2 Outputs
- `ec2_public_ip` - Public IP address of the EC2 instance
- `ec2_instance_id` - EC2 instance ID
- `ec2_ami_id` - AMI ID used for the instance
- `ec2_security_group_id` - Security group ID

#### S3 Outputs
- `s3_bucket_name` - S3 bucket name
- `s3_bucket_arn` - S3 bucket ARN
- `s3_bucket_region` - S3 bucket region
- `s3_bucket_domain_name` - S3 bucket domain name

## Security Best Practices

### SSH Access
```hcl
# ✅ Recommended: Restrict SSH to your IP
allowed_ssh_cidr = ["203.0.113.0/32"]

# ❌ Not recommended for production
allowed_ssh_cidr = ["0.0.0.0/0"]
```

### Public Ports
```hcl
# ✅ Only open necessary ports
ec2_open_tcp_ports = [80, 443]  # Web server only

# ❌ Avoid opening unnecessary ports
ec2_open_tcp_ports = [22, 80, 443, 3000, 8080]  # Too many
```

### SSH Keys
- Always use SSH key pairs for EC2 access
- Store `.pem` files securely in `~/.ssh/` with `chmod 400`
- Never commit SSH keys to version control
- Rotate keys regularly

### EBS Encryption
- Root volumes are encrypted by default
- Cannot be disabled in current configuration
- Uses AWS managed keys (aws/ebs)

### Tagging
```hcl
additional_tags = {
  Environment = "production"
  Project     = "MyProject"
  Team        = "DevOps"
  CostCenter  = "Engineering"
}
```

## Troubleshooting

### SSH Connection Issues

**Get SSH command from output:**
```bash
terraform output ssh_command
```

**Common issues:**
- Wrong username (check OS type)
- Wrong key file permissions: `chmod 400 ~/.ssh/your-key.pem`
- Security group not allowing your IP
- Instance not fully initialized (wait 2-3 minutes)

### AMI Not Found

If AMI lookup fails:
```hcl
# Specify AMI explicitly in terraform.tfvars
ami_id = "ami-xxxxxxxxx"  # Find in EC2 Console → AMI Catalog
```

### S3 Bucket Already Exists

S3 bucket names are globally unique:
```hcl
# Change bucket name
s3_bucket_name = "my-unique-bucket-name-2026"
```

## Cost Estimation

Approximate monthly costs (us-east-1):

| Resource | Configuration | Monthly Cost |
|----------|--------------|--------------|
| EC2 t2.micro | 24/7 running | ~$8.50 |
| EC2 t3.small | 24/7 running | ~$15.20 |
| EBS gp3 20GB | Storage | ~$1.60 |
| EBS gp3 50GB | Storage | ~$4.00 |
| S3 Standard | First 50TB | $0.023/GB |
| Data Transfer | Outbound | $0.09/GB |

💡 **Tip**: Use `terraform destroy` when not needed to avoid charges.

## Advanced Usage

### Multiple Environments

Create environment-specific tfvars:

```bash
# development.tfvars
environment = "dev"
instance_type = "t2.micro"

# production.tfvars
environment = "prod"
instance_type = "t3.medium"
```

Apply with:
```bash
terraform apply -var-file="production.tfvars"
```

### Custom VPC

```hcl
vpc_id = "vpc-xxxxx"
subnet_id = "subnet-xxxxx"
allowed_ssh_cidr = ["10.0.0.0/16"]  # VPC CIDR
enable_public_ip = false  # Private instance
```

### Spot Instances

Not currently supported. Consider adding to `ec2.tf`:
```hcl
instance_market_options {
  market_type = "spot"
}
```

## Contributing

When making changes:
1. Update variable descriptions
2. Run `terraform fmt` to format code
3. Run `terraform validate` to check syntax
4. Update README documentation
5. Test with `terraform plan`
6. Commit with descriptive messages

## License

This project is open source. Use at your own risk.

## Support

For issues or questions:
- Check this README
- Review Terraform documentation
- Check AWS documentation
- Open an issue on GitHub_open_tcp_ports = [80, 443]

# Development (Node.js, React, etc.)
ec2_open_tcp_ports = [80, 443, 3000, 8080]

# Windows RDP + Web
ec2_open_tcp_ports = [3389, 80, 443]

# Database server
ec2_open_tcp_ports = [3306]  # MySQL
ec2_open_tcp_ports = [5432]  # PostgreSQL

# Locked down (no public ports, SSH via allowed_ssh_cidr only)
ec2_open_tcp_ports = []
```

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
