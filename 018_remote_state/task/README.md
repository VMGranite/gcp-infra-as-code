# 018 — Remote State

**Goal:** move off local state and understand why teams don't commit
`terraform.tfstate` to git.

[Visit the Official Terraform GCS Backend Documentation Here](https://developer.hashicorp.com/terraform/language/backend/gcs)

## Tasks

1. Create a GCS bucket to hold state — you can do this once by hand
   (`gcloud storage buckets create`) or with a small bootstrap
   config, since a backend generally can't be created by the same
   configuration that uses it.
   - Enable `versioning` on this bucket so you can recover from a bad
     state write.
2. In `main.tf`, add a backend block:
   ```hcl
   terraform {
     backend "gcs" {
       bucket = "YOUR_STATE_BUCKET"
       prefix = "terraform-course/018-remote-state"
     }
   }
   ```
3. Run `terraform init` — Terraform should detect the backend change
   and offer to migrate your existing local state into GCS.
4. Confirm the state file now lives in the bucket:
   ```bash
   gcloud storage ls gs://YOUR_STATE_BUCKET/terraform-course/018-remote-state/
   ```
5. Delete your local `terraform.tfstate` (it should no longer be
   needed — GCS is now the source of truth) and run `terraform plan`
   again to confirm it still works.

## Success criteria

State lives in GCS, not on disk, and `terraform plan` works from a
clean checkout with no local state file.

## Discussion question

What problem does state *locking* solve, and how does the GCS backend
provide it?
