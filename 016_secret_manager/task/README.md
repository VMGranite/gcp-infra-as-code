# 016 — Secret Manager

**Goal:** store a sensitive value the right way — never hardcoded,
never printed in plan/apply output — and grant a service account
narrow access to read it.

[Visit the Official google_secret_manager_secret Resource Documentation Here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret)

## Setup

`variables.tf` already has `project_id`/`region` pre-filled — that
part goes back to [003_variables_and_outputs](../003_variables_and_outputs).
`terraform.tfvars` is already here too, committed with placeholder
values — just edit `project_id` to your real project ID.

This is the one exercise where a new variable does **not** follow the
usual "add it to `terraform.tfvars`" pattern — see step 2 below and
the discussion question for why.

## Tasks

1. Enable the Secret Manager API:
   ```bash
   gcloud services enable secretmanager.googleapis.com --project YOUR_PROJECT_ID
   ```
   or manage it with a `google_project_service` resource, as in
   earlier exercises.
2. Add a variable `secret_value` with `sensitive = true`. Do **not**
   give it a default, and do **not** add it to `terraform.tfvars` —
   you'll supply the real value another way instead. This is the
   first variable in the course that's actually different from
   `project_id`/`region`/`environment`/etc.: every one of those has
   been fine to write straight into a committed `terraform.tfvars`,
   because none of them are secrets — leaking your GCP project ID
   costs nothing. A real secret can't use that file at all, committed
   or not: `terraform.tfvars` is still a plaintext file sitting on
   disk, and "committed" vs. "gitignored" is the wrong axis for
   something like this — the answer isn't "hide the file," it's
   "never let the value touch a file." Two ways to supply it instead:
   ```bash
   # typed interactively, for this one command only:
   terraform apply -var="secret_value=whatever-you-want"

   # or as an environment variable Terraform reads automatically —
   # this is closer to how a real pipeline does it, pulling the
   # value from a vault (HashiCorp Vault, GCP Secret Manager itself,
   # a CI provider's secret store) into an env var right before
   # `terraform apply` runs, so no human ever types it and it's
   # never in shell history either:
   export TF_VAR_secret_value="whatever-you-want"
   terraform apply
   ```
3. Define a `google_secret_manager_secret` (secret ID `app-secret`)
   with automatic replication — Secret Manager stores encrypted
   copies of the secret's value across multiple regions so it's still
   available if one region has an outage; `auto {}` tells GCP to pick
   suitable regions for you instead of you naming them:
   ```hcl
   replication {
     auto {}
   }
   ```
4. Define a `google_secret_manager_secret_version` that stores
   `var.secret_value` in that secret.
5. Define a `google_service_account` named `secret-reader`.
6. Grant it `roles/secretmanager.secretAccessor` on **that one
   secret only** — via `google_secret_manager_secret_iam_member` —
   not a project-wide binding.
7. Run `terraform apply` using either method from step 2 — the point
   is that neither one ever wrote the value to a file.
8. Confirm the value is retrievable and that Terraform's own output
   never showed it in plaintext:
   ```bash
   gcloud secrets versions access latest --secret=app-secret
   ```

## Success criteria

- `terraform plan`/`apply` output never prints the raw secret value —
  it shows `(sensitive value)` instead.
- The `secret-reader` service account can access this one secret and
  nothing else.

## Discussion question

`sensitive = true` hides a value from CLI output, but does it encrypt
that value inside the Terraform **state file**? What does that imply
about how you should treat access to your state backend (see
[019_remote_state](../../019_remote_state))?
