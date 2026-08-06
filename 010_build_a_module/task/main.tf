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

# TODO: module "logs" {
#   source   = "./modules/bucket_with_lifecycle"
#   name     = "your-gcp-project-id-logs"
#   age_days = 14
# }

# TODO: module "backups" {
#   source   = "./modules/bucket_with_lifecycle"
#   name     = "your-gcp-project-id-backups"
#   age_days = 90
# }

# TODO: root outputs referencing module.logs.bucket_url and
#       module.backups.bucket_url
