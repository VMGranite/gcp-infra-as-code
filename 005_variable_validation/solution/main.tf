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

variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "retention_days" {
  type = number

  validation {
    condition     = var.retention_days > 0
    error_message = "retention_days must be a positive number."
  }
}

resource "google_storage_bucket" "this" {
  name                        = "${var.project_id}-${var.environment}-bucket"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true

  labels = {
    environment = var.environment
  }

  lifecycle_rule {
    condition {
      age = var.retention_days
    }
    action {
      type = "Delete"
    }
  }
}
