variable "project_id" {
  description = "GCP project ID to deploy resources into."
  type        = string
}

variable "region" {
  description = "Region for the provider default."
  type        = string
  default     = "us-central1"
}

# TODO: variable "secret_value" { sensitive = true, no default }
# Deliberately NOT added to terraform.tfvars.example or
# terraform.tfvars — see README.md for why secrets get a different
# workflow than project_id/region.
