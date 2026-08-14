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

# TODO: google_compute_network + google_compute_subnetwork (from exercise 008)

# TODO: resource "google_compute_firewall" "allow_ssh_iap" {
#   name    = "___"
#   network = ___  # reference the network resource above by its `id`
#
#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }
#
#   source_ranges = ["35.235.240.0/20"]
#   target_tags   = ["ssh"]
# }

# TODO: resource "google_compute_firewall" "allow_http" {
#   name    = "___"
#   network = ___
#
#   allow {
#     protocol = "tcp"
#     ports    = ["80"]
#   }
#
#   source_ranges = ["0.0.0.0/0"]
#   target_tags   = ["http-server"]
# }
#
# Optional: the google_compute_firewall docs page above has more under
# Argument Reference, e.g. `priority`, `direction`, `deny`.
