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

# TODO: google_compute_network resource (auto_create_subnetworks = false)

# TODO: google_compute_subnetwork resource referencing the network above
