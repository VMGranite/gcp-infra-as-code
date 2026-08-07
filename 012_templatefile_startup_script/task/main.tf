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
  zone    = "us-central1-a"
}

# TODO: variable "welcome_message" (string, default "Hello from Terraform templatefile()!")

# TODO: network, subnetwork, firewall rules (from 008/009/011)

# TODO: google_compute_instance "this" with:
# metadata_startup_script = templatefile("${path.module}/templates/startup.sh.tftpl", {
#   welcome_message = var.welcome_message
# })
