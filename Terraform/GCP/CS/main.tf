resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = var.gcp_region
  force_destroy = var.force_destroy

  uniform_bucket_level_access = var.uniform_bucket_level_access

  versioning {
    enabled = var.enable_versioning
  }

  dynamic "encryption" {
    for_each = var.kms_key_name != null ? [1] : []
    content {
      default_kms_key_name = var.kms_key_name
    }
  }

  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "google_storage_bucket_iam_binding" "public_rule" {
  count  = var.public_access ? 1 : 0
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
}
