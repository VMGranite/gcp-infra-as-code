# 006 — Solution: Uploading a File to Your Bucket

## What this creates

- **`google_storage_bucket`** (with `force_destroy = true` this time)
- **`google_storage_bucket_object`** — uploads `hello.txt` into that
  bucket.

## Why

This exercise isn't really about file uploads — it's about
**implicit dependencies**, one of the most important ideas in
Terraform. The object resource references the bucket with
`bucket = google_storage_bucket.my_bucket.name` instead of a literal
string. That reference is what tells Terraform "create the bucket
first, then the object" — you never had to write `depends_on`
yourself. Terraform builds this ordering automatically from every
place one resource's attributes reference another's.

In practice, this pattern (bucket + object) is how you'd ship static
website assets, Cloud Function source bundles, or config files that
need to exist alongside infrastructure you're also creating.

## Things worth noticing

- **`force_destroy = true`** is required here, and wasn't in exercise
  002 — GCS won't let you delete a bucket that still has objects in
  it, and Terraform doesn't automatically empty a bucket before
  destroying it unless told to.
- The `source` argument makes Terraform hash the local file's
  contents. Change `hello.txt` and run `terraform plan` again — the
  object resource shows as "will be updated in-place" because the
  hash changed, not because you told Terraform anything changed.
  This is how Terraform detects drift in file-backed resources
  generally.
