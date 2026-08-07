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

variable "environments" {
  type    = set(string)
  default = ["dev", "staging", "prod"]
}

resource "google_storage_bucket" "this" {
  for_each = var.environments

  name                        = "${var.project_id}-${each.value}-bucket"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true

  labels = {
    environment = each.value
  }
}
