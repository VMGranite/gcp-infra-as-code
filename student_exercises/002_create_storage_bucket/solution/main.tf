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

resource "google_storage_bucket" "my_bucket" {
  name                        = "your-gcp-project-id-exercise-002" # TODO: must be globally unique
  location                    = "US"
  uniform_bucket_level_access = true

  # Stretch goal
  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}
