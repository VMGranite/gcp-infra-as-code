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
  project = "" # TODO: your project ID
  region  = "us-central1"
}

variable "project_id" {
  type = string
}

# TODO: variable "environment" with a validation block restricting it
# to "dev", "staging", or "prod"

# TODO: variable "retention_days" with a validation block requiring
# a positive number

# TODO: google_storage_bucket "this" using var.environment in labels
# and var.retention_days in a lifecycle_rule
