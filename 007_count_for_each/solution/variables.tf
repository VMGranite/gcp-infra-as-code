variable "project_id" {
  description = "GCP project ID to deploy resources into."
  type        = string
}

variable "region" {
  description = "Region for the buckets and provider default."
  type        = string
  default     = "us-central1"
}

variable "bucket_environments" {
  description = "One bucket gets created per entry. Distinct from the single-value \"environment\" variable in 004/005 — this one is a list."
  type        = set(string)
  default     = ["dev", "staging", "prod"]
}
