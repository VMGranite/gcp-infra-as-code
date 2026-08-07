terraform {
  required_version = ">= 1.7.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  # Backend config can't reference variables — it has to be a literal.
  # Create this bucket by hand first (see README.md step 1), then
  # `terraform init` to migrate local state into it.
  backend "gcs" {
    bucket = "your-gcp-project-id-tf-state" # TODO: replace with your state bucket
    prefix = "terraform-course/017-remote-state"
  }
}

provider "google" {
  project = "your-gcp-project-id" # TODO: replace with your project ID
  region  = "us-central1"
}

resource "google_storage_bucket" "example" {
  name                        = "your-gcp-project-id-exercise-009" # TODO: must be globally unique
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
}
