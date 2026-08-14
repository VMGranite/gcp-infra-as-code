variable "project_id" {
  description = "GCP project ID to deploy resources into."
  type        = string
}

variable "region" {
  description = "Region for the bucket and provider default."
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Same variable introduced in 004_locals, now with a validation block added."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "retention_days" {
  description = "Number of days before objects in this bucket are deleted."
  type        = number
  default     = 30

  validation {
    condition     = var.retention_days > 0
    error_message = "retention_days must be a positive number."
  }
}
