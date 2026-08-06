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

data "google_project" "this" {
  project_id = "your-gcp-project-id" # TODO: replace with your project ID
}

output "project_display_name" {
  value = data.google_project.this.name
}
