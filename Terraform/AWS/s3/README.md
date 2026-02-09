# S3 Terraform Module

This module provisions an AWS S3 bucket with optional versioning, encryption, and public access controls.

## Running Standalone vs As a Module

This module can be used in two ways:

### 1. Standalone Execution (Run from s3/ directory)
The module can run independently using shared provider configuration via symlinks:
ln -sf ../.terraform s3/.terraform
- `providers.tf` → symlinked to `../providers.tf` ln -sf ../providers.tf providers.tf
- `.terraform/` → symlinked to `../.terraform/` (shared provider plugins)

```bash
cd s3/
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

- ✅ S3 bucket creation with unique naming
- ✅ Optional versioning for object history
- ✅ Server-side encryption (AES256) by default
- ✅ Public access blocking for security
- ✅ Comprehensive tagging strategy
- ✅ Production-ready configuration
- ✅ Simple and clean implementation

## Quick Start

1. **Copy and edit the configuration file:**
```bash
cp terraform.tfvars.example terraform.tfvars
vim terraform.tfvars
```

2. **Required: Set a globally unique bucket name:**
```hcl
bucket_name = "my-unique-bucket-name-12345"  # MUST be globally unique
```

3. **Initialize and apply:**
```bash
terraform init
terraform plan
terraform apply
```

4. **Get bucket information:**
```bash
terraform output bucket_name
terraform output bucket_arn
```

## Configuration

### Minimal Configuration

```hcl
# terraform.tfvars
aws_region  = "us-east-1"
aws_profile = "default"
environment = "dev"
project     = "my-project"

# S3 Settings
bucket_name = "my-unique-bucket-dev-2026"  # Must be globally unique
```

### Full Configuration Example

```hcl
# AWS Configuration
aws_region  = "us-east-1"
aws_profile = "default"

# Project Tags
environment = "production"
project     = "data-lake"

# S3 Configuration
bucket_name        = "company-data-lake-prod-2026"  # Globally unique
enable_versioning  = true
enable_encryption  = true

# Tags
tags = {
  ManagedBy   = "Terraform"
  Environment = "Production"
  DataClass   = "Confidential"
  CostCenter  = "Engineering"
  Compliance  = "Required"
}
```

## S3 Bucket Naming Rules

S3 bucket names must follow these rules:
- **Globally unique** across all AWS accounts
- 3-63 characters long
- Lowercase letters, numbers, hyphens, and periods only
- Must start and end with a letter or number
- Cannot be formatted as an IP address (e.g., 192.168.1.1)

### Good Bucket Names
✅ `my-app-data-prod-2026`  
✅ `company-backups-us-east-1`  
✅ `analytics.data.prod`  

### Bad Bucket Names
❌ `MyAppData` (uppercase)  
❌ `my_app_data` (underscore)  
❌ `ab` (too short)  
❌ `192.168.1.1` (IP format)  

## Variables

### Required Variables

| Name | Type | Description |
|------|------|-------------|
| `bucket_name` | string | S3 bucket name (must be globally unique) |

### AWS Configuration

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `aws_region` | string | `us-east-1` | AWS region for bucket |
| `aws_profile` | string | `default` | AWS CLI profile to use |
| `project` | string | `s3-standalone` | Project name for tagging |
| `environment` | string | `dev` | Environment name (dev/staging/prod) |

### S3 Configuration

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `bucket_name` | string | `gjpb-bucket` | S3 bucket name (globally unique) |
| `enable_versioning` | bool | `false` | Enable object versioning |
| `enable_encryption` | bool | `true` | Enable server-side encryption |
| `block_public_access` | bool | `true` | Block all public access |

### Tagging

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `tags` | map(string) | `{}` | Additional custom tags |

## Outputs

| Name | Description |
|------|-------------|
| `bucket_id` | S3 bucket ID (same as bucket name) |
| `bucket_arn` | S3 bucket ARN |
| `bucket_name` | S3 bucket name |
| `bucket_region` | S3 bucket region |

## Features Explained

### Versioning

When enabled, S3 keeps all versions of an object:
- **Recovery**: Restore previous versions of objects
- **Protection**: Recover from accidental deletions
- **Audit Trail**: Track changes over time

```hcl
enable_versioning = true
```

**Cost Impact**: Storage costs increase as old versions are retained. Consider lifecycle policies to manage costs.

### Encryption

Server-side encryption (AES256) protects data at rest:
- **Security**: Data encrypted on AWS servers
- **Compliance**: Meets many regulatory requirements
- **Transparent**: No impact on application code

```hcl
enable_encryption = true  # Recommended for all buckets
```

### Public Access Blocking

Blocks all public access to the bucket and objects:
- **Security**: Prevents accidental public exposure
- **Best Practice**: Enabled by default
- **Override**: Can be disabled if public access is required

```hcl
block_public_access = true  # Strongly recommended
```

## Usage Examples

### Basic Static Website Hosting Bucket

```hcl
bucket_name         = "my-website-2026"
enable_versioning   = true
enable_encryption   = true
block_public_access = false  # Website needs public access

tags = {
  Purpose = "Static Website"
  Public  = "true"
}
```

**Note**: For public websites, you'll need to add additional configuration for bucket policies and website settings.

### Application Backup Bucket

```hcl
bucket_name       = "app-backups-prod-2026"
enable_versioning = true  # Keep backup history
enable_encryption = true  # Encrypt backups

tags = {
  Purpose    = "Backups"
  Retention  = "30-days"
  Critical   = "true"
}
```

### Data Lake Storage

```hcl
bucket_name       = "data-lake-analytics-2026"
enable_versioning = false  # No versioning for large datasets
enable_encryption = true   # Encrypt data

tags = {
  Purpose     = "Data Lake"
  DataClass   = "Sensitive"
  Department  = "Analytics"
}
```

### Log Archive Bucket

```hcl
bucket_name       = "application-logs-archive-2026"
enable_versioning = false
enable_encryption = true

tags = {
  Purpose    = "Log Archive"
  Retention  = "90-days"
  Compliance = "Required"
}
```

## Accessing the Bucket

### AWS CLI Examples

```bash
# List bucket contents
aws s3 ls s3://$(terraform output -raw bucket_name)

# Upload a file
aws s3 cp myfile.txt s3://$(terraform output -raw bucket_name)/

# Download a file
aws s3 cp s3://$(terraform output -raw bucket_name)/myfile.txt ./

# Sync a directory
aws s3 sync ./local-dir s3://$(terraform output -raw bucket_name)/remote-dir/
```

### Using with Application Code

#### Python (boto3)
```python
import boto3

s3 = boto3.client('s3')
bucket_name = 'your-bucket-name'

# Upload file
s3.upload_file('local-file.txt', bucket_name, 'remote-file.txt')

# Download file
s3.download_file(bucket_name, 'remote-file.txt', 'local-file.txt')
```

#### Node.js (AWS SDK)
```javascript
const AWS = require('aws-sdk');
const s3 = new AWS.S3();
const bucketName = 'your-bucket-name';

// Upload file
await s3.putObject({
  Bucket: bucketName,
  Key: 'remote-file.txt',
  Body: fileContent
}).promise();

// Download file
const data = await s3.getObject({
  Bucket: bucketName,
  Key: 'remote-file.txt'
}).promise();
```

## Security Best Practices

1. **Enable Encryption**: Always use `enable_encryption = true` for sensitive data

2. **Block Public Access**: Keep `block_public_access = true` unless explicitly needed

3. **Use IAM Policies**: Grant least-privilege access via IAM roles and policies

4. **Enable Versioning**: For critical data, use versioning to prevent accidental deletion

5. **Bucket Policies**: Add bucket policies for fine-grained access control

6. **MFA Delete**: For production, consider enabling MFA delete for versioned buckets

7. **Access Logging**: Enable S3 access logging for audit trails

8. **Regular Audits**: Review bucket permissions and policies regularly

## Cost Optimization

1. **Versioning Impact**: Consider lifecycle policies to transition old versions to cheaper storage classes

2. **Storage Classes**: Use S3 Intelligent-Tiering or lifecycle policies for infrequent access

3. **Delete Unused Data**: Regularly clean up unnecessary objects

4. **Monitor Usage**: Use AWS Cost Explorer to track S3 costs

## Troubleshooting

### Issue: "BucketAlreadyExists"
**Solution**: S3 bucket names must be globally unique. Choose a different name:
```hcl
bucket_name = "my-app-${var.environment}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
```

### Issue: Cannot upload objects
**Solution**: Check IAM permissions and bucket policies. Ensure your IAM user/role has `s3:PutObject` permission.

### Issue: Bucket not found after creation
**Solution**: DNS propagation can take a few minutes. Wait and retry, or use the bucket ARN instead.

### Issue: Access denied errors
**Solution**: 
1. Verify IAM permissions
2. Check bucket policies
3. Ensure public access settings match your use case

## Advanced Configuration

### Adding Lifecycle Policies

For production use, consider adding lifecycle policies to manage costs:

```hcl
resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    id     = "archive-old-versions"
    status = "Enabled"

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}
```

### Adding CORS Configuration

For web applications accessing S3 from browsers:

```hcl
resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = aws_s3_bucket.s3_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["https://example.com"]
    max_age_seconds = 3000
  }
}
```

## Cleanup

To destroy the bucket and all its contents:

```bash
# Warning: This will delete all objects in the bucket
terraform destroy
```

**Note**: If versioning is enabled, you may need to delete all object versions manually before Terraform can destroy the bucket.

## License

MIT License - See parent repository for details.

## Author

Maintained by GJP DevOps Team
