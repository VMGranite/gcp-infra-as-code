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

# TODO: google_storage_bucket "this" using var.environment in labels
# and var.retention_days in a lifecycle_rule

provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  name_prefix = "${var.project_id}-${var.region}"

  common_labels = merge(
    { managed_by = "terraform" },
    { environment = var.environment }
  )
}

resource "google_storage_bucket" "this" {
  name                        = "${local.name_prefix}-bucket"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = local.common_labels
}