# 003 — Variables and Outputs

**Goal:** stop hardcoding values. Parameterize the bucket from
exercise 002 with variables, and expose useful values as outputs.

## Tasks

1. Create a `variables.tf` with:
   - `project_id` (string, no default — must be supplied)
   - `region` (string, default `"us-central1"`)
   - `bucket_name` (string, no default)
2. Update `main.tf` to reference `var.project_id`, `var.region`, and
   `var.bucket_name` instead of hardcoded values.
3. Create a `terraform.tfvars` (gitignored — don't commit it) with
   your actual values.
4. Create an `outputs.tf` with at least:
   - `bucket_url` — the bucket's `gs://` URL
   - `bucket_self_link` — the bucket's self link
5. Run `terraform apply` and confirm both outputs print correctly.

## Success criteria

Running `terraform apply -var="bucket_name=something-else"` (without
editing any `.tf` files) changes which bucket gets created — proof
the configuration is fully parameterized.

## Hints

- Variables without a `default` are required inputs — Terraform will
  prompt for them interactively if not supplied via `.tfvars` or
  `-var`.
- `terraform output <name>` prints a single output after apply.
