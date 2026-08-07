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

module "logs" {
  source = "./modules/bucket_with_lifecycle"

  name     = "your-gcp-project-id-logs" # TODO: must be globally unique
  age_days = 14
}

module "backups" {
  source = "./modules/bucket_with_lifecycle"

  name     = "your-gcp-project-id-backups" # TODO: must be globally unique
  age_days = 90
}
