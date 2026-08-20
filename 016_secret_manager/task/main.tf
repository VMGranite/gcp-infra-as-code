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

# TODO: google_project_service "secretmanager" (secretmanager.googleapis.com)

# TODO: google_secret_manager_secret "app_secret"
# - secret_id = "app-secret"
# - replication { auto {} }

# TODO: google_secret_manager_secret_version "app_secret_version"
# - secret      = reference to the secret above
# - secret_data = var.secret_value

# TODO: google_service_account "secret_reader"

# TODO: google_secret_manager_secret_iam_member granting secret_reader
#       roles/secretmanager.secretAccessor on the secret above
#       (not a project-level binding)
