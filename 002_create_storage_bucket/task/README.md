# 002 — Your First Resource: a Storage Bucket

**Goal:** create and destroy your first real GCP resource with
Terraform.

[Visit the Official Terraform Resource Block Documentation Here](https://developer.hashicorp.com/terraform/language/resources/syntax)

[Visit the Official google_storage_bucket Resource Documentation Here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)

## Tasks

1. In `main.tf`, fill in the `google_storage_bucket` block:
   ```hcl
   resource "google_storage_bucket" "my_bucket" {
     name = "..."
   }
   ```
   This is the first `resource` block you'll write in this course —
   it's the same two-label shape as the `data` block from
   [001_connect_to_gcp](../001_connect_to_gcp). `"google_storage_bucket"`
   is the resource **type**, fixed by the provider (it's exactly the
   page title on the docs link above — you can't invent your own
   type). `"my_bucket"` is a name *you* choose, used only to refer
   back to this resource elsewhere in your config; Terraform never
   sends it to GCP. Bucket names must be **globally unique** though —
   that's the `name` *argument's value* inside the block, a
   completely separate thing from the label — so include your project
   ID or another unique string there.
2. Set `location` to a region of your choice and
   `uniform_bucket_level_access = true`. Both are `argument = value`
   pairs inside the block — the docs page above lists every argument
   this resource type accepts under **Argument Reference**, marked
   `(Required)` or `(Optional)`, for whenever a `TODO` in this course
   names a resource but doesn't spell out every field.
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

Enable `versioning` and set a `lifecycle_rule` that deletes objects
older than 30 days — both are optional arguments on
`google_storage_bucket`. Find their exact shape in the **Argument
Reference** on the docs page linked above rather than guessing.
