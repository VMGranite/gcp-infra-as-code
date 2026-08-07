# 014 — Secret Manager

**Goal:** store a sensitive value the right way — never hardcoded,
never printed in plan/apply output — and grant a service account
narrow access to read it.

[Visit the Official google_secret_manager_secret Resource Documentation Here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret)

## Tasks

1. Enable the Secret Manager API:
   ```bash
   gcloud services enable secretmanager.googleapis.com --project YOUR_PROJECT_ID
   ```
   or manage it with a `google_project_service` resource, as in
   earlier exercises.
2. Add a variable `secret_value` with `sensitive = true`. Do **not**
   give it a default — you'll supply the real value at the command
   line, never in a committed file.
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
[017_remote_state](../../017_remote_state))?
