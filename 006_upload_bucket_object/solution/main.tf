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
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "my_bucket" {
  name                        = "${var.project_id}-exercise-006"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "hello" {
  name   = "hello.txt"
  bucket = google_storage_bucket.my_bucket.name
  source = "${path.module}/hello.txt"
}
