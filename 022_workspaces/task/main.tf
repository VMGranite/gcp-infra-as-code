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

# TODO: google_storage_bucket "this" whose name includes
# terraform.workspace — see README.md step 1.
