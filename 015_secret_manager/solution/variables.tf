variable "project_id" {
  description = "GCP project ID to deploy resources into."
  type        = string
}

variable "region" {
  description = "Region for the provider default."
  type        = string
  default     = "us-central1"
}

variable "secret_value" {
  description = "Value to store in Secret Manager. Pass with -var or TF_VAR_secret_value, never commit it — not even to a gitignored tfvars file."
  type        = string
  sensitive   = true
}
