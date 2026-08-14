variable "project_id" {
    type        = string
    description = "GCP project ID to deploy resources into."
}

variable "region" {
    type    = string
    description = "Region for the bucket and provider default."
    default = "us-central1"
}

variable "bucket_name" {
    type = string
}