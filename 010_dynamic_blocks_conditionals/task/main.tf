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

# TODO: variable "allowed_ports" (list of objects with protocol/ports)

# TODO: variable "environment" (string, default "dev")

# TODO: google_compute_network + google_compute_subnetwork (from 008/009)

# TODO: google_compute_firewall "this" with:
# - dynamic "allow" { for_each = var.allowed_ports; content { ... } }
# - source_ranges = var.environment == "prod" ? ["35.235.240.0/20"] : ["0.0.0.0/0"]
