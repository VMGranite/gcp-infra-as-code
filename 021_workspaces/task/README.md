# 021 — Workspaces

**Goal:** manage multiple environments from one configuration using
built-in Terraform workspaces — a different tradeoff than
[016_build_a_module](../016_build_a_module)'s "call the module
twice" approach, which you'll compare against directly in
[022_capstone_module](../022_capstone_module).

[Visit the Official Terraform Workspaces Documentation Here](https://developer.hashicorp.com/terraform/language/state/workspaces)

## Tasks

1. Define a single `google_storage_bucket` whose name incorporates
   `terraform.workspace`:
   ```hcl
   resource "google_storage_bucket" "this" {
     name                        = "${var.project_id}-${terraform.workspace}-bucket"
     location                    = "US"
     force_destroy               = true
     uniform_bucket_level_access = true
   }
   ```
2. Check what workspace you're in by default:
   ```bash
   terraform workspace list
   ```
   You should see `default` (with a `*`).
3. Create and switch to a new workspace, then apply:
   ```bash
   terraform workspace new dev
   terraform apply
   ```
4. Create a second workspace and apply again:
   ```bash
   terraform workspace new staging
   terraform apply
   ```
5. Compare what each workspace knows about:
   ```bash
   terraform workspace select dev
   terraform state list
   terraform workspace select staging
   terraform state list
   ```
6. Clean up **each** workspace before deleting it:
   ```bash
   terraform workspace select dev
   terraform destroy
   terraform workspace select staging
   terraform destroy
   terraform workspace select default
   terraform workspace delete dev
   terraform workspace delete staging
   ```

## Success criteria

Two buckets exist simultaneously (`...-dev-bucket` and
`...-staging-bucket`), created from **one** resource block with no
`count`/`for_each` — and `terraform state list` shows a completely
different result depending on which workspace is currently selected.

## Discussion question

Compare this to [016_build_a_module](../016_build_a_module) and
[022_capstone_module](../022_capstone_module), where "two
environments" meant calling a module twice in one `main.tf`, both
visible in a single `terraform plan`. With workspaces, could you ever
see `dev` and `staging`'s planned changes in the same `terraform
plan` output? What does that imply about the risk of running
`terraform apply` while forgetting which workspace you're currently
in?
