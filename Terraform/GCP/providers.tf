terraform {
  required_version = ">= 1.10"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  credentials = file("~/.gcp/gjp-service-account.json")
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}
