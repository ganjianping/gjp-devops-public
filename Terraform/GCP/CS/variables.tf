variable "bucket_name" {
  description = "Name of the Cloud Storage bucket"
  type        = string
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects"
  type        = bool
  default     = false
}

variable "uniform_bucket_level_access" {
  description = "Enables Uniform bucket-level access access to a bucket"
  type        = bool
  default     = true
}

variable "enable_versioning" {
  description = "While set to true, versioning is fully enabled for this bucket"
  type        = bool
  default     = false
}

variable "kms_key_name" {
  description = "A Cloud KMS key that will be used to encrypt objects inserted into this bucket"
  type        = string
  default     = null
}

variable "public_access" {
  description = "Whether to make the bucket publicly readable"
  type        = bool
  default     = false
}
