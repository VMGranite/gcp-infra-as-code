# 001 — Connect Terraform to GCP

**Goal:** get `terraform plan` talking to your GCP project without
creating any billable resources.

[Visit the Official Terraform + GCP Get Started Tutorial Here](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started)

## Tasks

1. Authenticate the gcloud CLI:
   ```bash
   gcloud auth application-default login
   gcloud config set project YOUR_PROJECT_ID
   ```
2. In `main.tf`, fill in the `required_providers` block and a
   `provider "google"` block pointed at your project.
3. Add a `data "google_project" "this"` data source that looks up
   your own project.
4. Add an `output` that prints the project's display name from that
   data source.
5. Run `terraform init` then `terraform plan` — no resources should
   be created (plan should show 0 to add), but the output should
   resolve correctly.

## Success criteria

`terraform plan` succeeds and shows the correct project name in the
planned output — proof Terraform can authenticate to and read from
your GCP project.

## Hints

- `data` blocks don't create anything; they read existing state from
  the provider. This is a safe way to test a connection.
- If `plan` fails with a permissions error, check that your account
  has at least `roles/viewer` on the project.
