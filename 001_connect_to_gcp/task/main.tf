terraform {
  required_version = ">= 1.7.0"

  required_providers {
    google = {
      source = "hashicorp/google"
      # TODO: pin a provider version, e.g. "~> 5.0"
      version = ""
    }
  }
}

provider "google" {
  # TODO: project = "___" (optionally region/zone too)
}

# TODO: data "google_project" "this" {
#   # No arguments required — an empty block looks up the provider's
#   # default project. See the Argument Reference on the docs page
#   # above for what else this data source accepts.
# }

# TODO: output "project_display_name" {
#   value = data.google_project.this.___
#   # See the Attributes Reference on the docs page above for the
#   # exact attribute name that holds the human-readable project name.
# }
