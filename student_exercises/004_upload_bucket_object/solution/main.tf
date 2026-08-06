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
  name                        = "your-gcp-project-id-exercise-004" # TODO: must be globally unique
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "hello" {
  name   = "hello.txt"
  bucket = google_storage_bucket.my_bucket.name
  source = "${path.module}/hello.txt"
}
