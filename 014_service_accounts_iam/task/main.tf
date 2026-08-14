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
  zone    = "us-central1-a"
}

# TODO: google_storage_bucket resource (something to scope IAM to)

# TODO: google_service_account "vm_runner"

# TODO: google_storage_bucket_iam_member granting vm_runner
#       roles/storage.objectViewer on the bucket above (not project-wide)

# TODO: network, subnetwork, firewall rules (from exercise 012)

# TODO: google_compute_instance using the vm_runner service account
#       (see exercise 012 for the rest of the instance config)
