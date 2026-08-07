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

resource "google_project_service" "compute" {
  project            = "your-gcp-project-id" # TODO: replace with your project ID
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_network" "example" {
  name                    = "example-network"
  auto_create_subnetworks = false

  depends_on = [google_project_service.compute]
}

resource "google_compute_subnetwork" "example" {
  name          = "example-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.example.id
}
