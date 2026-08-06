# 009 — Solution: Secret Manager

## What this creates

- **`google_secret_manager_secret`** + **`google_secret_manager_secret_version`**
  — a secret named `app-secret` holding one version's worth of data.
- **`google_service_account.secret_reader`** — a dedicated identity.
- **`google_secret_manager_secret_iam_member`** — grants
  `secret_reader` `roles/secretmanager.secretAccessor`, on that one
  secret only.

## Why not just use a variable with a default, or an env var baked into a startup script

Both are common shortcuts, and both leave the secret sitting in
plaintext somewhere durable — a `default` value lives in your `.tf`
files (and your git history, forever, even if you remove it later); a
value baked into a startup script sits in plaintext in the instance's
metadata, readable by anything with `compute.instances.get` on that
VM. Secret Manager exists specifically to break that pattern: the
value is stored once, access is controlled by IAM like any other
resource, and every access is logged.

## Why `sensitive = true` on the variable

Without it, `terraform plan` and `terraform apply` print every value
they touch — including this one — directly to your terminal, your CI
logs, and anywhere else that output ends up. `sensitive = true` masks
it in all Terraform-produced output, replacing it with
`(sensitive value)`. It does **not** encrypt or omit the value from
the state file — Terraform state still contains it in plaintext,
which is exactly why [011_remote_state](../../011_remote_state)'s
README calls out treating your state backend's IAM as sensitive
infrastructure in its own right. `sensitive = true` protects against
*accidental* exposure (a log dump, a screen share, a CI artifact) —
it isn't a substitute for restricting who can read your state.

## Why a dedicated service account instead of granting yourself access

You already have access via your own `gcloud auth login` session —
this exercise's `secret_reader` account exists to model what a
*workload* (a VM, a Cloud Function, a CI pipeline) would use to read
the secret at runtime, with only the one permission it needs. Same
least-privilege pattern as [008_service_accounts_iam](../../008_service_accounts_iam),
applied to a new resource type.

## Things worth noticing

- `google_secret_manager_secret` and
  `google_secret_manager_secret_version` are two separate resources
  on purpose — a secret can have multiple versions over its lifetime
  (e.g. after rotation), and most consumers are written to fetch
  "latest" rather than pin to one version.
- Passing `-var="secret_value=..."` on the command line keeps the
  value out of any file on disk, but it does land in your shell
  history — for real usage you'd typically pull it from something
  like a CI secret store instead of typing it interactively.
