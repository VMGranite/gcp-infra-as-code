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
  project = "your-gcp-project-id" # TODO: replace with your project ID
  region  = "us-central1"
}

variable "project_id" {
  type    = string
  default = "your-gcp-project-id" # TODO: replace with your project ID
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "environment" {
  type    = string
  default = "dev"
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
