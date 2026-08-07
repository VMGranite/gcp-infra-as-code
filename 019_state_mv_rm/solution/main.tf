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

# Started as "legacy", ended as "renamed" — see README.md for the
# terraform state mv / rm / import sequence that got it here without
# ever destroying the real bucket.
resource "google_storage_bucket" "renamed" {
  name                        = "your-gcp-project-id-state-mv-demo" # TODO: must be globally unique
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
}
