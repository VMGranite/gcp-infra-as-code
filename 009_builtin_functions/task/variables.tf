variable "project_id" {
  description = "GCP project ID to deploy resources into."
  type        = string
}

variable "region" {
  description = "Region for the subnets and provider default."
  type        = string
  default     = "us-central1"
}

variable "network_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_names" {
  type    = list(string)
  default = ["dev", "staging", "prod"]
}
