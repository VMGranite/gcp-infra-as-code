variable "project_id" {
  description = "GCP project ID to deploy resources into."
  type        = string
}

variable "region" {
  description = "Region for the buckets and provider default."
  type        = string
  default     = "us-central1"
}

# TODO: variable "bucket_environments" { type = set(string), default = ["dev", "staging", "prod"] }
# Named differently from the "environment" variable in 004/005 on
# purpose: that one is a single value, this one is a *list* — one
# bucket gets created per entry.
