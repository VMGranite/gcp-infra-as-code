# Example Project

A minimal but complete Terraform + GCP template: provider connection,
API enablement, storage, networking, firewall, and a compute instance.
Use this as the reference to look back at while working through the
numbered exercises at the repo root.

## What's here

| File | Purpose |
|---|---|
| `versions.tf` | Terraform and provider version constraints |
| `variables.tf` | Input variables (`project_id`, `region`, `zone`, `labels`) |
| `main.tf` | Provider config + resources |
| `outputs.tf` | Values printed after `apply` |
| `terraform.tfvars.example` | Template for your own `terraform.tfvars` |

## Resources created

- **`google_project_service`** — enables the Compute Engine and Cloud
  Storage APIs
- **`google_storage_bucket`** — a Cloud Storage bucket
- **`google_compute_network`** + **`google_compute_subnetwork`** — a
  custom VPC and one subnet
- **`google_compute_firewall`** — allows SSH only from Google's
  Identity-Aware Proxy range
- **`google_compute_instance`** — an `e2-micro` VM (Always Free tier
  eligible in `us-central1`, `us-west1`, `us-east1`)

## Prerequisites

1. A GCP project with billing enabled (the free tier covers this
   template if you stay in an eligible region).
2. [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.7.
3. [gcloud CLI](https://cloud.google.com/sdk/docs/install), authenticated:

   ```bash
   gcloud auth application-default login
   gcloud config set project YOUR_PROJECT_ID
   ```

   This is the recommended way to authenticate Terraform to GCP for
   local learning — it uses your own user credentials, so there's no
   service account key file to manage or accidentally commit.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your project ID

terraform init
terraform plan
terraform apply
```

When you're done experimenting:

```bash
terraform destroy
```

## Basic GCP resources worth knowing for an intro course

Beyond what's wired up here, these are the resources students will
run into constantly and are worth calling out explicitly:

- `google_project_service` — enabling APIs is a prerequisite most
  beginners forget and then get confused by the resulting error.
- `google_storage_bucket` / `google_storage_bucket_object` — cheap,
  fast, no networking concepts required. Good "hello world."
- `google_compute_network`, `google_compute_subnetwork`,
  `google_compute_firewall` — the networking trio; teaches that GCP
  networking is explicit, not implied.
- `google_compute_instance` — the classic VM resource.
- `google_service_account` + `google_project_iam_member` — IAM basics
  and least-privilege access.
- `google_storage_bucket_iam_member` — resource-level IAM as opposed
  to project-level.
- `random_id` (from the `hashicorp/random` provider) — commonly paired
  with bucket names, which must be globally unique.
- A `backend "gcs"` block — remote state, once students are ready to
  move past local state.
