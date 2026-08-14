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

# TODO: google_project_service "compute" (compute.googleapis.com) —
# optional if you already ran `gcloud services enable` by hand, see
# README.md step 1

# TODO: google_compute_network resource (auto_create_subnetworks = false)

# TODO: google_compute_subnetwork resource referencing the network above
