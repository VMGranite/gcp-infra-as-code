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

# TODO: network, subnetwork, firewall rules (from exercises 008/010)

# TODO: google_compute_instance "example"
# - machine_type = "e2-micro"
# - tags = ["ssh", "http-server"]
# - boot_disk { initialize_params { image = "debian-cloud/debian-12" } }
# - network_interface { subnetwork = ...; access_config {} }
# - metadata_startup_script = <<-EOT
#     #!/bin/bash
#     apt-get update
#     apt-get install -y apache2
#   EOT
