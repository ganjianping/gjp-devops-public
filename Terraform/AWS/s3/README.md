# S3 Terraform Module

This module provisions an AWS S3 bucket with optional versioning, encryption, and public access controls.

## Features

- S3 bucket creation
- Optional versioning
- Optional server-side encryption (AES256)
- Optional public access blocking
- Bucket name validation
- AWS credentials from `~/.aws/credentials`
- AWS region from `~/.aws/config`
- Shared provider configuration (uses `../providers.tf`)

## Requirements

- Terraform >= 1.10
- AWS CLI configured
- Unique S3 bucket name (globally unique across all AWS accounts)
- Parent folder must contain `providers.tf`

## Usage

This module is called from the parent AWS directory. Do not run terraform commands directly in this folder.

**From the parent AWS directory:**

```bash
# S3 only
terraform apply -var="create_ec2=false"

# With custom bucket name
terraform apply -var="create_ec2=false" -var="s3_bucket_name=my-bucket-2026"

# With versioning enabled
terraform apply -var="create_ec2=false" -var="enable_versioning=true"

# Public bucket
terraform apply -var="create_ec2=false" -var="block_public_access=false"
```

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `s3_bucket_name` | string | `gjpb-bucket` | S3 bucket name (must be globally unique) |
| `enable_versioning` | bool | `false` | Enable bucket versioning |
| `enable_encryption` | bool | `true` | Enable server-side encryption |
| `block_public_access` | bool | `true` | Block all public access |

## Outputs

- `s3_bucket_name` - Bucket name
- `s3_bucket_arn` - Bucket ARN
- `s3_bucket_region` - Bucket region
- `s3_bucket_domain_name` - Bucket domain name

## Examples

### Basic Storage Bucket
```hcl
s3_bucket_name = "my-app-storage-2026"
enable_versioning = false
enable_encryption = true
block_public_access = true
```

### Versioned Backup Bucket
```hcl
s3_bucket_name = "my-backup-bucket-2026"
enable_versioning = true
enable_encryption = true
block_public_access = true
```

### Public Website Bucket
```hcl
s3_bucket_name = "my-website-bucket-2026"
enable_versioning = false
enable_encryption = false
block_public_access = false
```

## Bucket Naming Rules

- 3-63 characters long
- Can contain lowercase letters, numbers, hyphens, and periods
- Must start and end with a letter or number
- Cannot contain consecutive periods
- Must be globally unique across ALL AWS accounts

## Security Best Practices

✅ **Recommended Settings:**
- `enable_encryption = true` - Protect data at rest
- `block_public_access = true` - Prevent accidental public exposure
- `enable_versioning = true` - Enable recovery from accidental deletion

⚠️ **Warning**: Setting `block_public_access = false` can expose your data publicly. Only do this if you're hosting a public website.

## Clean Up

```bash
# Empty bucket first (if it contains objects)
aws s3 rm s3://your-bucket-name --recursive

# Then destroy
terraform destroy
```

## Common Issues

**Error: BucketAlreadyExists**
- S3 bucket names are globally unique
- Change `s3_bucket_name` to a unique value

**Error: AccessDenied when destroying**
- Bucket must be empty before deletion
- Run: `aws s3 rm s3://your-bucket-name --recursive`
