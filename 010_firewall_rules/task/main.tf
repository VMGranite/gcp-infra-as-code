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

# TODO: google_compute_network + google_compute_subnetwork (from exercise 005)

# TODO: google_compute_firewall "allow_ssh_iap"
# - source_ranges = ["35.235.240.0/20"]
# - target_tags   = ["ssh"]

# TODO: google_compute_firewall "allow_http"
# - source_ranges = ["0.0.0.0/0"]
# - target_tags   = ["http-server"]
