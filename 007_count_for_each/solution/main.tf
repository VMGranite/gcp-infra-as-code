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
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "this" {
  for_each = var.bucket_environments

  name                        = "${var.project_id}-${each.value}-bucket"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true

  labels = {
    environment = each.value
  }
}
