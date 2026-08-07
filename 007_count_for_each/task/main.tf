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

# TODO: variable "environments" { type = set(string), default = ["dev", "staging", "prod"] }

# TODO: google_storage_bucket "this" with for_each = var.environments

# TODO: output "bucket_urls" mapping each environment to its bucket's url
