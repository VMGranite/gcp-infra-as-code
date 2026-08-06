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

variable "secret_value" {
  description = "Value to store in Secret Manager. Pass with -var, never commit it."
  type        = string
  sensitive   = true
}

resource "google_project_service" "secretmanager" {
  project            = "your-gcp-project-id" # TODO: replace with your project ID
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_secret_manager_secret" "app_secret" {
  secret_id = "app-secret"

  replication {
    auto {}
  }

  depends_on = [google_project_service.secretmanager]
}

resource "google_secret_manager_secret_version" "app_secret_version" {
  secret      = google_secret_manager_secret.app_secret.id
  secret_data = var.secret_value
}

resource "google_service_account" "secret_reader" {
  account_id   = "secret-reader"
  display_name = "Secret reader (exercise 009)"
}

# Scoped to this one secret only — not project-wide secret access.
resource "google_secret_manager_secret_iam_member" "secret_reader_accessor" {
  secret_id = google_secret_manager_secret.app_secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.secret_reader.email}"
}
