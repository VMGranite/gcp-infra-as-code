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
  zone    = "us-central1-a"
}

variable "welcome_message" {
  type    = string
  default = "Hello from Terraform templatefile()!"
}

resource "google_project_service" "compute" {
  project            = "your-gcp-project-id" # TODO: replace with your project ID
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_network" "this" {
  name                    = "templatefile-network"
  auto_create_subnetworks = false

  depends_on = [google_project_service.compute]
}

resource "google_compute_subnetwork" "this" {
  name          = "templatefile-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.this.id
}

resource "google_compute_firewall" "allow_ssh_iap" {
  name    = "templatefile-allow-ssh-iap"
  network = google_compute_network.this.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "templatefile-allow-http"
  network = google_compute_network.this.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_instance" "this" {
  name         = "templatefile-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  tags         = ["ssh", "http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.this.id
    access_config {}
  }

  metadata_startup_script = templatefile("${path.module}/templates/startup.sh.tftpl", {
    welcome_message = var.welcome_message
  })

  depends_on = [google_project_service.compute]
}
