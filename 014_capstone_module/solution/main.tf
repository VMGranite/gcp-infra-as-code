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
  zone    = "us-central1-a"
}

resource "google_project_service" "compute" {
  project            = "your-gcp-project-id" # TODO: replace with your project ID
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

module "dev" {
  source = "./modules/vm_with_network"

  name_prefix = "dev"
  region      = "us-central1"
  zone        = "us-central1-a"
  subnet_cidr = "10.0.1.0/24"

  depends_on = [google_project_service.compute]
}

module "staging" {
  source = "./modules/vm_with_network"

  name_prefix = "staging"
  region      = "us-central1"
  zone        = "us-central1-a"
  subnet_cidr = "10.0.2.0/24"

  depends_on = [google_project_service.compute]
}
