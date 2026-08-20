# 016 — Secret Manager

**Goal:** store a sensitive value the right way — Terraform manages
the secret's *existence* and *who can read it*, but never the value
itself.

[Visit the Official google_secret_manager_secret Resource Documentation Here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret)

[Visit the Official Secret Manager: Add a Secret Version Documentation Here](https://cloud.google.com/secret-manager/docs/add-secret-version)

## Why the value never goes through Terraform at all

The obvious approach is a `sensitive = true` variable, passed to a
`google_secret_manager_secret_version` resource. Don't do that here —
`sensitive = true` only masks a value from `plan`/`apply` **output**;
it does nothing to the **state file**. Once a value flows into any
resource argument, Terraform writes it to `terraform.tfstate` in
plaintext, permanently, regardless of how carefully you typed it in.
Whether you passed it via `-var`, an environment variable, or hand-typed
it into a prompt doesn't matter — the moment it's a Terraform-managed
value, it's sitting in your state file.

The actual fix isn't a safer way to type the value — it's to never let
it become a Terraform-managed value in the first place. This exercise
has Terraform create the secret **container** (`google_secret_manager_secret`)
and the **access control** (who can read it), and stops there. The
value itself gets added afterward, directly against the Secret Manager
API — outside Terraform's plan/apply/state pipeline entirely, the same
way a real pipeline injects secrets from a vault at deploy time rather
than writing them into the infrastructure code that provisions the
vault.

## Setup

`variables.tf` already has `project_id`/`region` pre-filled — that
part goes back to [003_variables_and_outputs](../003_variables_and_outputs).
`terraform.tfvars` is already here too, committed with placeholder
values — just edit `project_id` to your real project ID.

## Tasks

1. Enable the Secret Manager API:
   ```bash
   gcloud services enable secretmanager.googleapis.com --project YOUR_PROJECT_ID
   ```
   or manage it with a `google_project_service` resource, as in
   earlier exercises.
2. Define a `google_secret_manager_secret` (secret ID `app-secret`)
   with automatic replication — Secret Manager stores encrypted
   copies of the secret's value across multiple regions so it's still
   available if one region has an outage; `auto {}` tells GCP to pick
   suitable regions for you instead of you naming them:
   ```hcl
   replication {
     auto {}
   }
   ```
   Do **not** define a `google_secret_manager_secret_version` resource
   — that's the whole point of this exercise.
3. Define a `google_service_account` named `secret-reader`, and grant
   it `roles/secretmanager.secretAccessor` on **that one secret only**
   — via `google_secret_manager_secret_iam_member` — not a
   project-wide binding.
4. Run `terraform apply`. Confirm the secret exists but has no version
   yet:
   ```bash
   gcloud secrets versions list app-secret
   # (empty — Listed 0 items.)
   ```
5. Add the actual value **outside Terraform**, using either method —
   they're equivalent, pick whichever you want to practice:

   **gcloud:**
   ```bash
   echo -n "whatever-value-you-want" | gcloud secrets versions add app-secret --data-file=-
   ```
   `--data-file=-` reads the value from stdin instead of a command-line
   argument or a file on disk — nothing here ends up in your shell
   history or a temp file the way `--data-file=/tmp/secret.txt` or a
   literal value typed as an argument would.

   **GCP Console:**
   1. Console → search bar → "Secret Manager" (or Navigation menu →
      Security → Secret Manager).
   2. Click into `app-secret`.
   3. Click **+ NEW VERSION**, paste the value into the field, click
      **ADD NEW VERSION**.
6. Run `terraform plan` — confirm it shows **no changes**. Terraform
   has no resource tracking the secret's version, so it has nothing to
   notice or reconcile.
7. Confirm the value never touched Terraform's own bookkeeping:
   ```bash
   grep -r "whatever-value-you-want" terraform.tfstate
   ```
   This should return nothing. Compare that to what would happen if
   you'd used a `google_secret_manager_secret_version` resource with
   `secret_data = var.secret_value` instead — grep the state file for
   that value, and it would be right there in plaintext.
8. Confirm the value is retrievable through Secret Manager itself
   (this is the access path a real workload would use, via IAM, not
   via Terraform):
   ```bash
   gcloud secrets versions access latest --secret=app-secret
   ```
   To view it in the Console: `app-secret`'s page → the version's row
   → the "view" (eye) icon, or **Actions → View secret value**.

## Success criteria

- `terraform state list` shows the secret container and the IAM
  binding — Terraform manages both.
- No `google_secret_manager_secret_version` resource exists anywhere
  in your `.tf` files.
- Grepping `terraform.tfstate` for the value you chose in step 5 finds
  nothing.
- `gcloud secrets versions access latest --secret=app-secret` (or the
  Console) successfully returns the value.

## Discussion question

If you'd used a `sensitive = true` variable and a
`google_secret_manager_secret_version` resource instead, `terraform
plan`/`apply` output would never have shown the value — but it would
still be sitting in `terraform.tfstate` in plaintext. Now that the
value never touches Terraform at all, what's actually protecting it?
(See [019_remote_state](../019_remote_state) and
[020_state_bucket_least_privilege](../020_state_bucket_least_privilege)
for what — or who — that answer points to.)
