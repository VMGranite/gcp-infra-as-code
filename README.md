# Terraform + GCP: Intro Course

Start with [000_start_here](000_start_here) — it walks through
finding your GCP project ID, authenticating, and the `init`/`plan`/
`apply`/`destroy` workflow you'll repeat in every exercise below.
Then work through the twenty-four numbered exercises in order of
increasing difficulty. Each folder is self-contained: work inside it,
don't reference other exercises' state.

Each numbered exercise folder has two subfolders:

- **`task/`** — the README and starter code (with `TODO`s) you work
  from.
- **`solution/`** — a complete, working implementation. Try the
  exercise yourself first — the solution is there to check your work
  or unstick you, not to copy before attempting it.

| # | Exercise | Concepts |
|---|---|---|
| [000_start_here](000_start_here) | Get your project ID, authenticate, learn the Terraform workflow | `gcloud auth`, `init`/`plan`/`apply`/`destroy` |
| [001_connect_to_gcp](001_connect_to_gcp/task) | Connect Terraform to GCP | provider, auth, `init`/`plan` |
| [002_create_storage_bucket](002_create_storage_bucket/task) | Your first resource: a storage bucket | resources, `apply`/`destroy` |
| [003_variables_and_outputs](003_variables_and_outputs/task) | Variables and outputs | `variable`, `output`, `terraform.tfvars` |
| [004_locals](004_locals/task) | Locals | `locals`, derived values, `merge()` |
| [005_variable_validation](005_variable_validation/task) | Variable validation | `validation` blocks, fail-fast errors |
| [006_upload_bucket_object](006_upload_bucket_object/task) | Uploading a file to your bucket | resource dependencies |
| [007_count_for_each](007_count_for_each/task) | count / for_each | multiple resources from one block |
| [008_create_vpc_network](008_create_vpc_network/task) | A custom VPC network | `google_compute_network`/`subnetwork` |
| [009_builtin_functions](009_builtin_functions/task) | Built-in functions | `cidrsubnet()`, `format()`, `jsonencode()` |
| [010_firewall_rules](010_firewall_rules/task) | Firewall rules | `google_compute_firewall`, least privilege |
| [011_dynamic_blocks_conditionals](011_dynamic_blocks_conditionals/task) | Dynamic blocks and conditionals | `dynamic`, ternary expressions |
| [012_create_vm](012_create_vm/task) | Deploy a VM | `google_compute_instance`, startup scripts |
| [013_templatefile_startup_script](013_templatefile_startup_script) | templatefile() (Part 1: render to output, Part 2: VM startup script) | rendering config files, `templatefile()` |
| [014_service_accounts_iam](014_service_accounts_iam/task) | Service accounts and IAM | least-privilege IAM |
| [015_secret_manager](015_secret_manager/task) | Secret Manager | sensitive variables, `google_secret_manager_secret` |
| [016_provider_aliases](016_provider_aliases/task) | Provider aliases | `alias`, multi-region/multi-project |
| [017_build_a_module](017_build_a_module/task) | Build a module | modules, `source`, reusability |
| [018_remote_state](018_remote_state/task) | Remote state | `backend "gcs"`, state locking |
| [019_state_bucket_least_privilege](019_state_bucket_least_privilege/task) | Least-privilege access to the state bucket | scoped IAM, `google_storage_bucket_iam_member` |
| [020_configuration_drift](020_configuration_drift/task) | Configuration drift | `plan`, `apply -refresh-only`, state vs. reality |
| [021_audit_log_alerts](021_audit_log_alerts/task) | Alerting on manual (non-Terraform) changes | Cloud Audit Logs, log-based metrics, alert policies |
| [022_state_mv_rm](022_state_mv_rm/task) | terraform state mv / rm | refactoring addresses without destroying resources |
| [023_import_existing_resources](023_import_existing_resources/task) | Migrating existing resources | `import` blocks, `-generate-config-out` |
| [024_capstone_module](024_capstone_module/task) | Capstone: build a module | modules, capstone project |

## General setup

See [000_start_here](000_start_here) for finding your project
ID, authenticating, and the full `init`/`plan`/`apply`/`destroy`
workflow. Always run `terraform destroy` before moving to the next
exercise so you aren't paying for resources you're done with.
