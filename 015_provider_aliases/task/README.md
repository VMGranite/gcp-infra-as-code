# 015 — Provider Aliases

**Goal:** manage resources targeting two different configurations
(here, two regions) from one Terraform configuration, using a second,
aliased `provider` block.

[Visit the Official Terraform Provider Configuration Documentation Here](https://developer.hashicorp.com/terraform/language/providers/configuration)

## Tasks

1. Keep your default `provider "google"` block (region
   `us-central1`).
2. Add a second, **aliased** provider block for a different region:
   ```hcl
   provider "google" {
     alias   = "europe"
     project = var.project_id
     region  = "europe-west1"
   }
   ```
3. Define **one** `google_compute_network` (global — networks aren't
   regional, so the default provider is fine here).
4. Define **two** `google_compute_subnetwork` resources, each with a
   distinct, non-overlapping `ip_cidr_range` — but don't set their
   `region` argument explicitly on either one. Instead:
   - Leave one using the default provider (no `provider` argument
     needed).
   - Set `provider = google.europe` on the other.
5. Run `terraform apply`, then confirm each subnet landed in the
   region its provider was configured for:
   ```bash
   gcloud compute networks subnets list --format="table(name,region)"
   ```

## Success criteria

Two subnets exist in the same network, in two different regions,
without either `google_compute_subnetwork` block setting `region`
directly — the region came from *which provider* created each one.

## Discussion question

`google_compute_subnetwork` actually has its own `region` argument —
you could get the same result by setting it explicitly on each
resource and skipping the aliased provider entirely. Given that, what
kinds of differences between two target configurations *can't* be
expressed as a resource-level argument, and would force you to reach
for a provider alias instead?
