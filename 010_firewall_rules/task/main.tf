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

resource "google_project_service" "compute" {
  project            = var.project_id
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
  region        = var.region
  network       = google_compute_network.example.id
}

resource "google_compute_firewall" "allow_ssh_iap" {
   name    = "allow-ssh-iap"
   network = google_compute_network.example.id

   allow {
     protocol = "tcp"
     ports    = ["22"]
   }

   source_ranges = ["35.235.240.0/20"]
   target_tags   = ["ssh"]
 }

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.example.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

