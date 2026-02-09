# EC2 Terraform Module

This module provisions an AWS EC2 instance with production-ready configuration including security groups, SSH access, encrypted EBS volumes, and flexible networking.

## Running Standalone vs As a Module

This module can be used in two ways:

### 1. Standalone Execution (Run from ec2/ directory)
The module can run independently using shared provider configuration via symlinks:
- `providers.tf` → symlinked to `../providers.tf` ln -sf ../providers.tf providers.tf
- `.terraform/` → symlinked to `../.terraform/` (shared provider plugins) ln -sf ../.terraform ec2/.terraform

```bash
cd ec2/
terraform init    # Uses shared .terraform directory
terraform plan
terraform apply
```

### 2. As a Module (Called from root directory)
The module is called from the parent directory's `main.tf` with variables passed in:

```bash
cd ..  # Go to Terraform/AWS/
terraform init
terraform plan
terraform apply
```

## Features

- ✅ Multiple OS support (Ubuntu, Amazon Linux, RHEL, Debian, CentOS, Windows)
- ✅ Latest AMI via data source (region-agnostic, no hardcoded IDs)
- ✅ Custom or default VPC/subnet support
- ✅ SSH key pair integration for secure access
- ✅ Configurable CIDR-based security group rules
- ✅ Encrypted EBS volumes by default
- ✅ Multiple additional EBS volume support
- ✅ Comprehensive tagging strategy
- ✅ Public IP association control
- ✅ Customizable instance type and storage

## Quick Start

1. **Copy and edit the configuration file:**
```bash
cp terraform.tfvars.example terraform.tfvars
vim terraform.tfvars
```

2. **Required: Set your SSH key name:**
```hcl
ssh_key_name = "your-key-name"  # MUST be an existing AWS key pair
```

3. **Initialize and apply:**
```bash
terraform init
terraform plan
terraform apply
```

4. **Get SSH connection details:**
```bash
terraform output ssh_command
```

## Configuration

### Minimal Configuration

```hcl
# terraform.tfvars
aws_region   = "us-east-1"
aws_profile  = "default"
environment  = "dev"
project      = "my-project"

# EC2 Settings
instance_type = "t2.micro"
os_type       = "ubuntu"
ssh_key_name  = "my-existing-key"  # Required!
```

### Full Configuration Example

```hcl
# AWS Configuration
aws_region  = "us-east-1"
aws_profile = "default"

# Project Tags
environment = "production"
project     = "web-server"

# EC2 Configuration
instance_type = "t3.medium"
os_type       = "amazon-linux"

# Networking (optional - uses default VPC if not specified)
vpc_id    = "vpc-12345678"
subnet_id = "subnet-12345678"

# Security
ssh_key_name        = "my-production-key"
allowed_ssh_cidrs   = ["203.0.113.0/24"]  # Restrict to your IP
additional_sg_cidrs = ["0.0.0.0/0"]

# Storage
root_volume_size = 30
root_volume_type = "gp3"
encrypted        = true

# Additional volumes
additional_volumes = [
  {
    device_name = "/dev/sdf"
    volume_size = 100
    volume_type = "gp3"
    encrypted   = true
  }
]

# Tags
tags = {
  ManagedBy   = "Terraform"
  Environment = "Production"
  CostCenter  = "Engineering"
}
```

## Supported Operating Systems

| OS Type | Description | Latest AMI |
|---------|-------------|------------|
| `ubuntu` | Ubuntu Server (latest) | Auto-detected |
| `amazon-linux` | Amazon Linux 2023 | Auto-detected |
| `rhel` | Red Hat Enterprise Linux 9 | Auto-detected |
| `debian` | Debian (latest) | Auto-detected |
| `centos` | CentOS Stream 9 | Auto-detected |
| `windows` | Windows Server 2022 | Auto-detected |

## Variables

### Required Variables

| Name | Type | Description |
|------|------|-------------|
| `ssh_key_name` | string | Name of existing AWS SSH key pair for instance access |

### AWS Configuration

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `aws_region` | string | `us-east-1` | AWS region for resources |
| `aws_profile` | string | `default` | AWS CLI profile to use |
| `project` | string | `ec2-standalone` | Project name for tagging |
| `environment` | string | `dev` | Environment name (dev/staging/prod) |

### EC2 Configuration

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `os_type` | string | `ubuntu` | Operating system type |
| `instance_type` | string | `t2.micro` | EC2 instance type |
| `enable_public_ip` | bool | `true` | Associate public IP address |

### Networking

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `vpc_id` | string | `""` | VPC ID (empty for default VPC) |
| `subnet_id` | string | `""` | Subnet ID (empty for default subnet) |
| `allowed_ssh_cidrs` | list(string) | `["0.0.0.0/0"]` | CIDR blocks allowed SSH access |
| `additional_sg_cidrs` | list(string) | `["0.0.0.0/0"]` | Additional CIDR blocks for security group |

### Storage

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `root_volume_size` | number | `8` | Root EBS volume size in GB |
| `root_volume_type` | string | `gp3` | Root EBS volume type |
| `encrypted` | bool | `true` | Enable EBS encryption |
| `additional_volumes` | list(object) | `[]` | Additional EBS volumes to attach |

### Tagging

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `tags` | map(string) | `{}` | Additional custom tags |

## Outputs

| Name | Description |
|------|-------------|
| `instance_id` | EC2 instance ID |
| `instance_public_ip` | Public IP address (if enabled) |
| `instance_private_ip` | Private IP address |
| `instance_public_dns` | Public DNS name |
| `security_group_id` | Security group ID |
| `security_group_name` | Security group name |
| `key_name` | SSH key pair name |
| `ssh_command` | Ready-to-use SSH command |

## SSH Connection

After deployment, use the `ssh_command` output to connect:

```bash
# Get the SSH command
terraform output -raw ssh_command

# Example output:
# ssh -i ~/.ssh/my-key.pem ubuntu@54.123.45.67

# Or connect directly
ssh -i ~/.ssh/your-key.pem ubuntu@$(terraform output -raw instance_public_ip)
```

## Security Best Practices

1. **Restrict SSH Access**: Always limit `allowed_ssh_cidrs` to your IP range
```hcl
allowed_ssh_cidrs = ["203.0.113.0/24"]  # Your office/home IP range
```

2. **Enable Encryption**: Keep `encrypted = true` for all EBS volumes

3. **Use Private Subnets**: For production, deploy in private subnets with bastion host

4. **Regular Updates**: Keep OS and packages updated after deployment

5. **Key Management**: Store SSH private keys securely, never commit to version control

## Examples

### Web Server with Additional Storage

```hcl
environment  = "production"
project      = "web-app"
instance_type = "t3.medium"
os_type       = "ubuntu"
ssh_key_name  = "web-server-key"

root_volume_size = 20
additional_volumes = [
  {
    device_name = "/dev/sdf"
    volume_size = 100
    volume_type = "gp3"
    encrypted   = true
  }
]

allowed_ssh_cidrs = ["203.0.113.0/24"]
```

### Development Instance

```hcl
environment  = "dev"
project      = "test-server"
instance_type = "t2.micro"
os_type       = "amazon-linux"
ssh_key_name  = "dev-key"

root_volume_size = 8
allowed_ssh_cidrs = ["0.0.0.0/0"]  # OK for dev/testing
```

### High-Performance Database Server

```hcl
environment  = "production"
project      = "database"
instance_type = "r6i.2xlarge"
os_type       = "rhel"
ssh_key_name  = "db-key"

root_volume_size = 50
root_volume_type = "io2"

additional_volumes = [
  {
    device_name = "/dev/sdf"
    volume_size = 500
    volume_type = "io2"
    encrypted   = true
  }
]

allowed_ssh_cidrs = ["10.0.0.0/8"]  # Internal network only
```

## Troubleshooting

### Issue: "InvalidKeyPair.NotFound"
**Solution**: The SSH key must exist in AWS before running terraform. Create it first:
```bash
aws ec2 create-key-pair --key-name my-key --query 'KeyMaterial' --output text > ~/.ssh/my-key.pem
chmod 400 ~/.ssh/my-key.pem
```

### Issue: "AMI not found"
**Solution**: The data source filters may need adjustment for your region. Check available AMIs:
```bash
aws ec2 describe-images --owners amazon --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"
```

### Issue: Cannot SSH to instance
**Solution**: 
1. Check security group allows your IP
2. Verify instance has public IP
3. Ensure you're using correct username (ubuntu/ec2-user/admin)
4. Check key permissions: `chmod 400 ~/.ssh/your-key.pem`

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

## License

MIT License - See parent repository for details.

## Author

Maintained by GJP DevOps Team
