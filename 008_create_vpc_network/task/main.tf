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

# TODO: resource "google_project_service" "compute" {
#   project            = var.project_id
#   service            = "compute.googleapis.com"
#   disable_on_destroy = false
# }
# Optional if you already ran `gcloud services enable` by hand — see
# README.md step 1.

# TODO: resource "google_compute_network" "example" {
#   name                    = "___"
#   auto_create_subnetworks = false
# }

# TODO: resource "google_compute_subnetwork" "example" {
#   name          = "___"
#   ip_cidr_range = "___"  # a /24, e.g. "10.0.1.0/24"
#   region        = var.region
#   network       = ___  # reference the network resource above by its `id`
#
#   # Optional: the google_compute_subnetwork docs page above has more
#   # under Argument Reference, e.g. `private_ip_google_access`.
# }
