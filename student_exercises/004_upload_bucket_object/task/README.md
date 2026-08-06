# 004 — Uploading a File to Your Bucket

**Goal:** understand implicit resource dependencies by creating a
bucket and an object inside it in the same configuration.

## Tasks

1. Create a `hello.txt` file in this folder with any text content.
2. In `main.tf`, define a `google_storage_bucket` (reuse what you
   built in exercise 002/003).
3. Add a `google_storage_bucket_object` resource that uploads
   `hello.txt` into that bucket using the `source` argument.
4. Run `terraform apply` and verify with:
   ```bash
   gcloud storage cat gs://YOUR_BUCKET/hello.txt
   ```
5. Change the contents of `hello.txt` and run `terraform plan` again.
   Notice Terraform detects the change via the file's hash and plans
   an in-place update.

## Success criteria

`terraform apply` creates both the bucket and the object in the
correct order — without you specifying an explicit `depends_on`.

## Discussion question

Why didn't you need a `depends_on` between the bucket and the object?
(Hint: look at what argument the object resource uses to reference
the bucket.)
