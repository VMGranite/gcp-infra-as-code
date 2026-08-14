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
  project = "var.project_name" # TODO: your project ID
  region  = "var.region"
}


# TODO: resource "google_storage_bucket" "my_bucket" {
#   # same shape as 002_create_storage_bucket — but instead of literal
#   # strings, wire it to your new variables:
#   name                        = var.bucket_name
#   location                    = var.region
#   uniform_bucket_level_access = true
# }
resource "google_storage_bucket" "my_bucket" {
  name="var.bucket_name"
  location="var.region"
  uniform_bucket_level_access =  true
}