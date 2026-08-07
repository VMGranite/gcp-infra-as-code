# 002 — Your First Resource: a Storage Bucket

**Goal:** create and destroy your first real GCP resource with
Terraform.

[Visit the Official Terraform Resource Block Documentation Here](https://developer.hashicorp.com/terraform/language/resources/syntax)

## Tasks

1. In `main.tf`, define a `google_storage_bucket` resource. Bucket
   names must be **globally unique**, so include your project ID or
   another unique string in the name.
2. Set `location` to a region of your choice and
   `uniform_bucket_level_access = true`.
3. Run `terraform init`, `terraform plan`, then `terraform apply`.
4. Confirm the bucket exists:
   ```bash
   gcloud storage buckets list --project YOUR_PROJECT_ID
   ```
5. Run `terraform destroy` and confirm the bucket is gone.

## Success criteria

You can create the bucket with `apply`, see it in `gcloud`, and
remove it cleanly with `destroy`.

## Stretch goal

Enable `versioning` on the bucket and set a `lifecycle_rule` that
deletes objects older than 30 days.
