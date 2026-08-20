# 019 — Least-Privilege Access to the State Bucket

**Goal:** apply the same least-privilege pattern from
[014_service_accounts_iam](../014_service_accounts_iam) to the state
bucket from [018_remote_state](../018_remote_state) itself, instead of
leaving it reachable by whatever broad access already exists on the
project.

[Visit the Official google_storage_bucket_iam_member Resource Documentation Here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam)

## Why this matters

Your state file is arguably the most sensitive artifact in this whole
course — it's a complete record of every resource you manage, and
(per [015_secret_manager](../015_secret_manager)'s discussion
question) it can contain plaintext values even when your code marks
them `sensitive`. Access to it deserves the same scrutiny as
production credentials, not "whoever happens to be Owner on the
project."

`state_runner` below stands in for "whatever runs `terraform apply`"
in a real setup — a CI pipeline, typically, which is a distinct
identity from any engineer's own account. Scoping *that* identity
narrowly is the actual point: read/write access to state objects,
nothing that lets it touch the bucket's own IAM policy. Alongside it,
you'll grant your own user a second, deliberately weaker binding —
because "someone who runs applies" and "someone who occasionally
needs to look at state while debugging" are different needs, and
least privilege means neither one should be stretched to cover the
other.

## Setup

`variables.tf` already has `project_id`/`region` pre-filled — that
part goes back to [003_variables_and_outputs](../003_variables_and_outputs).
`terraform.tfvars` is already here too, committed with placeholder
values — edit `project_id`, `state_bucket_name` (the bucket you made
by hand in [018_remote_state](../018_remote_state)), and `your_email`
(the output of `gcloud config get-value account`) to your real values.

## Tasks

1. The backend block already points at your state bucket with a new
   prefix for this exercise — edit the bucket name to match 018's.
2. Define a `google_service_account` named `state_runner`.
3. Grant it `roles/storage.objectAdmin` on `var.state_bucket_name`
   **only**, via `google_storage_bucket_iam_member` — enough to read
   and write state objects. Do **not** grant `roles/storage.admin`,
   and do not grant anything at the project level.
4. Grant your own user (`var.your_email`) `roles/storage.objectViewer`
   on the same bucket, via a second `google_storage_bucket_iam_member`
   — read-only, standing in for a human who needs to inspect state
   while debugging, with none of `state_runner`'s write access.
5. Run `terraform apply`.
6. Confirm the scope from outside Terraform:
   ```bash
   gcloud storage buckets get-iam-policy gs://YOUR_STATE_BUCKET --format=json
   ```
   `state_runner` should appear with exactly `roles/storage.objectAdmin`,
   and your own user with exactly `roles/storage.objectViewer` — no
   binding anywhere on this bucket should grant either of them (or
   anyone else) `roles/storage.admin` or the ability to change the
   bucket's own IAM policy.

## Success criteria

The state bucket's IAM policy has exactly two bindings: `state_runner`
scoped to `roles/storage.objectAdmin`, and your own user scoped to
`roles/storage.objectViewer` — nothing broader, and nothing
project-level.

## Discussion question

`state_runner`'s own permissions were defined by a `terraform apply`
you ran as *yourself* — not as `state_runner`. If `state_runner` were
the identity that ran every apply going forward, who's actually
allowed to change what `state_runner` can do, and through what path?
Does managing that boundary in Terraform defeat the purpose, since
whoever can apply this config could also loosen it — or is the real
fix about *which* identity is allowed to apply configs that touch
`state_runner`'s own bindings, rather than whether the tool is
Terraform at all?
