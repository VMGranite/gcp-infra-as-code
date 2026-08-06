variable "project_id" {
  description = "GCP project ID to deploy resources into."
  type        = string
}

variable "region" {
  description = "Default GCP region."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Default GCP zone."
  type        = string
  default     = "us-central1-a"
}

variable "labels" {
  description = "Common labels applied to resources that support them."
  type        = map(string)
  default = {
    course = "intro-to-terraform-gcp"
  }
}
