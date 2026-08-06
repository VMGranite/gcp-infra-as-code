terraform {
  required_version = ">= 1.7.0"

  required_providers {
    google = {
      source = "hashicorp/google"
      # TODO: pin a provider version, e.g. "~> 5.0"
      version = ""
    }
  }
}

provider "google" {
  # TODO: set project (and optionally region/zone)
}

# TODO: add a `data "google_project" "this"` block

# TODO: add an output that prints the project's display name
