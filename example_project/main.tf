provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Enable the APIs this project needs before Terraform can create
# resources that depend on them.
resource "google_project_service" "apis" {
  for_each = toset([
    "compute.googleapis.com",
    "storage.googleapis.com",
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

# A Cloud Storage bucket. Cheap, fast to create/destroy, and a good
# first resource for getting comfortable with the Terraform workflow.
resource "google_storage_bucket" "example" {
  name                        = "${var.project_id}-example-bucket"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = var.labels

  depends_on = [google_project_service.apis]
}

# A custom VPC (no auto-created subnets) so students can see networking
# as something Terraform manages explicitly, not a default.
resource "google_compute_network" "example" {
  name                    = "example-network"
  auto_create_subnetworks = false

  depends_on = [google_project_service.apis]
}

resource "google_compute_subnetwork" "example" {
  name          = "example-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.example.id
}

# Allow SSH only from Identity-Aware Proxy's range, not the whole
# internet. Demonstrates least-privilege firewall design.
resource "google_compute_firewall" "allow_ssh_iap" {
  name    = "allow-ssh-iap"
  network = google_compute_network.example.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["ssh"]
}

# e2-micro is eligible for GCP's Always Free tier in us-central1,
# us-west1, and us-east1 — a reasonable default VM for students to
# experiment with at little to no cost.
resource "google_compute_instance" "example" {
  name         = "example-vm"
  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["ssh"]
  labels       = var.labels

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.example.id
    access_config {} # ephemeral public IP
  }

  depends_on = [google_project_service.apis]
}
