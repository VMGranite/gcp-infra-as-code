# 001 — Solution: Connect Terraform to GCP

## What this creates

- Nothing billable. A `data "google_project"` lookup and an output —
  no `resource` blocks at all.

## Why

The goal here isn't infrastructure, it's proving the *connection*
works before you risk creating anything real. A `data` source is
read-only: it asks the provider to look something up, but can't
create, modify, or delete anything. That makes it the safest possible
way to sanity-check authentication — if `terraform plan` succeeds and
prints your project's display name, you know the provider, your
credentials, and your project ID are all correctly wired together.

## Things worth noticing

- `terraform plan` on this config always shows "0 to add, 0 to
  change, 0 to destroy" — that's expected and correct. You're
  reading, not writing.
- If this fails, the error tells you *where* the chain is broken: a
  provider/version error means step 2 of setup is wrong, an auth
  error means [000_start_here](../../000_start_here) step 2
  wasn't completed (specifically `gcloud auth application-default
  login`), and a "project not found" error usually means a typo in
  the project ID.
- There's nothing to `destroy` for this exercise — no resources were
  created.
- The `data "google_project"` block doesn't set `project_id` — it
  inherits the provider's configured project automatically. That's
  deliberate: your project ID only needs to be edited in one place
  (the `provider` block). If it were duplicated in the data source
  too, editing only the provider block would leave a stale value
  behind, and you'd get a "project not found" error that has nothing
  to do with your actual credentials or project ID being wrong.
