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
