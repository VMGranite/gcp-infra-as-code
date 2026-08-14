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

# TODO: resource "google_storage_bucket" "my_bucket" {
#   name                        = "___"  # must be globally unique — include your project ID
#   location                    = "___"  # a region or multi-region, e.g. "US"
#   uniform_bucket_level_access = ___    # true
#
#   # Optional: the docs page above has an Argument Reference listing
#   # everything else this resource accepts — you'll use two more of
#   # them for the stretch goal below.
# }
