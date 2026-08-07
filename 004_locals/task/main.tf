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

variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "environment" {
  type    = string
  default = "dev"
}

# TODO: locals {
#   name_prefix   = "${var.project_id}-${var.region}"
#   common_labels = merge({ managed_by = "terraform" }, { environment = var.environment })
# }

# TODO: google_storage_bucket "this" using local.name_prefix for its
# name and local.common_labels for its labels
