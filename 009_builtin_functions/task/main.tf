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

variable "network_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_names" {
  type    = list(string)
  default = ["dev", "staging", "prod"]
}

# TODO: google_compute_network "this" (custom mode)

# TODO: google_compute_subnetwork "this" with for_each = toset(var.subnet_names)
# - ip_cidr_range = cidrsubnet(var.network_cidr, 8, index(var.subnet_names, each.value))
# - name          = format("%s-%s-subnet", var.project_id, each.value)

# TODO: google_storage_bucket "this" (reuse the pattern from earlier exercises)

# TODO: google_storage_bucket_object "network_manifest" with
# content = jsonencode({ network_cidr = var.network_cidr, subnets = { ... } })
