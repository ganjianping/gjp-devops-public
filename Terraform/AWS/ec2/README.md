# EC2 Terraform Module

This module provisions an AWS EC2 instance with configurable OS type, instance type, and security group rules.

## Features

- Multiple OS support (Ubuntu, Amazon Linux, RHEL, Debian, CentOS, Windows)
- Latest AMI via data source (no hardcoded AMI IDs)
- Public IP assignment
- Configurable security group with dynamic TCP port rules
- Uses default VPC
- AWS credentials from `~/.aws/credentials`
- AWS region from `~/.aws/config`
- Shared provider configuration (uses `../providers.tf`)

## Requirements

- Terraform >= 1.10
- AWS CLI configured
- Default VPC must exist
- Parent folder must contain `providers.tf`

## Usage

This module is called from the parent AWS directory. Do not run terraform commands directly in this folder.

**From the parent AWS directory:**

```bash
# EC2 only
terraform apply -var="create_s3=false"

# With custom OS
terraform apply -var="create_s3=false" -var="os_type=amazon-linux-2023"

# With custom ports
terraform apply -var="create_s3=false" -var="ec2_open_tcp_ports=[22,80,443]"
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

## Outputs

- `ec2_public_ip` - Public IP address
- `ec2_instance_id` - Instance ID
- `ec2_ami_id` - AMI ID used
- `ec2_security_group_id` - Security group ID

## Examples

### Web Server (Linux)
```hcl
instance_type = "t3.small"
os_type = "ubuntu"
ec2_open_tcp_ports = [22, 80, 443]
```

### Development Environment
```hcl
instance_type = "t3.medium"
os_type = "amazon-linux-2023"
ec2_open_tcp_ports = [22, 80, 443, 3000, 8080]
```

### Windows Server
```hcl
instance_type = "t3.medium"
os_type = "windows-2022"
ec2_open_tcp_ports = [3389, 80, 443]
```

### Database Server
```hcl
instance_type = "t3.small"
os_type = "ubuntu"
ec2_open_tcp_ports = [22, 3306]  # MySQL
```

## Security Notes

⚠️ **Warning**: This configuration allows inbound traffic from anywhere (0.0.0.0/0). For production:
- Restrict `cidr_blocks` to specific IP ranges
- Use AWS Systems Manager Session Manager instead of opening SSH/RDP
- Implement VPC with private subnets
- Add EC2 key pair for SSH access

## Clean Up

```bash
terraform destroy
```
