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

resource "google_project_service" "compute" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_network" "this" {
  name                    = "builtin-functions-network"
  auto_create_subnetworks = false

  depends_on = [google_project_service.compute]
}

resource "google_compute_subnetwork" "this" {
  for_each = toset(var.subnet_names)

  name          = format("%s-%s-subnet", var.project_id, each.value)
  ip_cidr_range = cidrsubnet(var.network_cidr, 8, index(var.subnet_names, each.value))
  region        = var.region
  network       = google_compute_network.this.id
}

resource "google_storage_bucket" "this" {
  name                        = "${var.project_id}-builtin-functions-bucket"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "network_manifest" {
  name   = "network-manifest.json"
  bucket = google_storage_bucket.this.name
  content = jsonencode({
    network_cidr = var.network_cidr
    subnets      = { for name, s in google_compute_subnetwork.this : name => s.ip_cidr_range }
  })
}
