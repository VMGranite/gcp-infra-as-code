# 015 — Secret Manager

**Goal:** store a sensitive value the right way — never hardcoded,
never printed in plan/apply output — and grant a service account
narrow access to read it.

[Visit the Official google_secret_manager_secret Resource Documentation Here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret)

## Setup

`variables.tf` already has `project_id`/`region` pre-filled, same as
every exercise since [003_variables_and_outputs](../003_variables_and_outputs).

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars and set project_id to your real project ID
```

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
   you'll supply the real value at the command line instead. This is
   different from every variable so far: `project_id`/`region` are
   fine to keep in a gitignored `terraform.tfvars` because leaking
   them is low-stakes and being able to `terraform plan` without
   retyping them every time matters. A secret is the opposite
   trade-off — a `terraform.tfvars` is still a plaintext file
   sitting on disk, easy to `git add` by mistake or leave on a
   shared machine, so it never gets written to a file at all.
3. Define a `google_secret_manager_secret` (secret ID `app-secret`)
   with automatic replication:
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
7. Apply, passing the value directly so it never touches a file:
   ```bash
   terraform apply -var="secret_value=whatever-you-want"
   ```
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
[018_remote_state](../../018_remote_state))?
