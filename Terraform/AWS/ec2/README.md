# EC2 Terraform Module

This module provisions an AWS EC2 instance with production-ready configuration including security groups, SSH access, encrypted EBS volumes, and flexible networking.

## Features

- ✅ Multiple OS support (Ubuntu, Amazon Linux, RHEL, Debian, CentOS, Windows)
- ✅ Latest AMI via data source (region-agnostic, no hardcoded IDs)
- ✅ Custom or default VPC/subnet support
- ✅ SSH key pair integration for secure access
- ✅ Configurable security groups with SSH CIDR restrictions
- ✅ Dynamic TCP port rules (HTTP, HTTPS, custom ports)
- ✅ Encrypted EBS root volume (by default)
- ✅ Configurable volume size and type (gp2/gp3/io1/io2)
- ✅ Public/private IP options
- ✅ Resource tagging with environment and custom tags
- ✅ SSH command helper in outputs

## Requirements

- Terraform >= 1.10
- AWS CLI configured
- Parent folder must contain `providers.tf`
- (Optional) SSH key pair for instance access

## Module Inputs

| Variable | Type | Description | Required |
|----------|------|-------------|----------|
| `vpc_id` | string | VPC ID (empty = default VPC) | No |
| `subnet_id` | string | Subnet ID (empty = default subnet) | No |
| `instance_name` | string | Name tag for EC2 instance | Yes |
| `os_type` | string | Operating system type | Yes |
| `ami_id` | string | Specific AMI ID (empty = auto-select) | No |
| `instance_type` | string | EC2 instance type | Yes |
| `key_name` | string | SSH key pair name | No |
| `public_key_path` | string | Path to SSH public key | No |
| `enable_public_ip` | bool | Associate public IP address | Yes |
| `allowed_ssh_cidr` | list(string) | CIDR blocks for SSH access | Yes |
| `ec2_open_tcp_ports` | list(number) | TCP ports open from anywhere | Yes |
| `root_volume_size` | number | Root EBS volume size (GB) | Yes |
| `root_volume_type` | string | Root EBS volume type | Yes |
| `additional_tags` | map(string) | Additional resource tags | Yes |

## Module Outputs

| Output | Description |
|--------|-------------|
| `ec2_public_ip` | Public IP address |
| `instance_private_ip` | Private IP address |
| `instance_public_dns` | Public DNS name |
| `ec2_instance_id` | Instance ID |
| `instance_state` | Instance state |
| `ec2_ami_id` | AMI ID used |
| `ec2_security_group_id` | Security group ID |
| `ssh_command` | Ready-to-use SSH command |

## Usage

This module is called from the parent AWS directory. **Do not run terraform commands directly in this folder.**

**From the parent AWS directory:**

```bash
# EC2 only with SSH key
terraform apply -var="create_s3=false" -var="key_name=my-key"

# With custom OS and restricted SSH
terraform apply -var="create_s3=false" -var="os_type=amazon-linux-2023" -var='allowed_ssh_cidr=["203.0.113.0/24"]'

# With custom VPC and larger volume
terraform apply -var="create_s3=false" -var="vpc_id=vpc-xxxxx" -var="subnet_id=subnet-xxxxx" -var="root_volume_size=50"
```

## Supported Operating Systems

| os_type | OS Name | Owner |
|---------|---------|-------|
| `ubuntu` | Ubuntu 22.04 LTS | Canonical |
| `amazon-linux-2` | Amazon Linux 2 | Amazon |
| `amazon-linux-2023` | Amazon Linux 2023 | Amazon |
| `rhel` | RHEL 9 | Red Hat |
| `debian` | Debian 12 | Debian |
| `centos` | CentOS Stream 9 | CentOS |
| `windows-2022` | Windows Server 2022 | Amazon |
| `windows-2019` | Windows Server 2019 | Amazon |

## Configuration Examples

### Web Server (Ubuntu)
```hcl
# In parent terraform.tfvars
instance_name = "web-server"
instance_type = "t3.small"
os_type = "ubuntu"
key_name = "my-web-key"
allowed_ssh_cidr = ["203.0.113.0/24"]
ec2_open_tcp_ports = [80, 443]
root_volume_size = 30
```

### Development Environment
```hcl
instance_name = "dev-server"
instance_type = "t3.medium"
os_type = "amazon-linux-2023"
key_name = "dev-key"
ec2_open_tcp_ports = [80, 443, 3000, 8080]
root_volume_size = 50
root_volume_type = "gp3"
```

### Windows Server
```hcl
instance_name = "windows-app"
instance_type = "t3.medium"
os_type = "windows-2022"
ec2_open_tcp_ports = [3389, 80, 443]
root_volume_size = 50
```

### Private Instance (VPC)
```hcl
instance_name = "private-app"
vpc_id = "vpc-xxxxx"
subnet_id = "subnet-xxxxx"
enable_public_ip = false
allowed_ssh_cidr = ["10.0.0.0/16"]
ec2_open_tcp_ports = []
```

## Security Features

### SSH Access Control
- Separate SSH ingress rule with configurable CIDR blocks
- Default allows from anywhere (0.0.0.0/0) - **change for production**
- SSH command output includes correct username per OS type

### EBS Encryption
- Root volume encrypted by default
- Uses AWS managed encryption (aws/ebs)
- Cannot be disabled (security best practice)

### Security Group
- Dynamic port rules based on configuration
- All outbound traffic allowed
- Named based on instance name for easy identification

## SSH Connection

After deployment, get the SSH command:

```bash
terraform output ssh_command
```

Example outputs:
- Ubuntu: `ssh -i ~/.ssh/my-key.pem ubuntu@54.x.x.x`
- Amazon Linux: `ssh -i ~/.ssh/my-key.pem ec2-user@54.x.x.x`
- Windows: `Use RDP to connect to 54.x.x.x`

## Security Notes

⚠️ **Production Recommendations**:
- ✅ Set `allowed_ssh_cidr` to your specific IP/CIDR
- ✅ Use SSH keys (never password authentication)
- ✅ Minimize `ec2_open_tcp_ports` to only required ports
- ✅ Consider AWS Systems Manager Session Manager for SSH
- ✅ Use private subnets with bastion host or VPN
- ✅ Enable CloudWatch monitoring
- ✅ Regular security group audits
terraform destroy
```
