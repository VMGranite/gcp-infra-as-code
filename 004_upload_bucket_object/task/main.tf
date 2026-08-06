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
  project = "" # TODO
  region  = "us-central1"
}

# TODO: google_storage_bucket resource

# TODO: google_storage_bucket_object resource
# - bucket = reference the bucket resource above (not a hardcoded name)
# - source = "hello.txt"
