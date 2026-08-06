terraform {
  required_version = ">= 1.7.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  # TODO: reference var.project_id and var.region
}

# TODO: define a google_storage_bucket resource using var.bucket_name
