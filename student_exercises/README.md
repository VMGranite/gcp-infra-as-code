# Student Exercises

Start with [000_exercise_setup](000_exercise_setup) — it walks through
finding your GCP project ID, authenticating, and the `init`/`plan`/
`apply`/`destroy` workflow you'll repeat in every exercise below.
Then work through the fourteen numbered exercises in order of
increasing difficulty. Each folder is self-contained: work inside it,
don't reference other exercises' state. Look at `../example_project`
any time you get stuck — it demonstrates every resource type used
below.

Each numbered exercise folder has two subfolders:

- **`task/`** — the README and starter code (with `TODO`s) you work
  from.
- **`solution/`** — a complete, working implementation. Try the
  exercise yourself first — the solution is there to check your work
  or unstick you, not to copy before attempting it.

| # | Exercise | Concepts |
|---|---|---|
| [000_exercise_setup](000_exercise_setup) | Get your project ID, authenticate, learn the Terraform workflow | `gcloud auth`, `init`/`plan`/`apply`/`destroy` |
| [001_connect_to_gcp](001_connect_to_gcp/task) | Connect Terraform to GCP | provider, auth, `init`/`plan` |
| [002_create_storage_bucket](002_create_storage_bucket/task) | Your first resource: a storage bucket | resources, `apply`/`destroy` |
| [003_variables_and_outputs](003_variables_and_outputs/task) | Variables and outputs | `variable`, `output`, `terraform.tfvars` |
| [004_upload_bucket_object](004_upload_bucket_object/task) | Uploading a file to your bucket | resource dependencies |
| [005_create_vpc_network](005_create_vpc_network/task) | A custom VPC network | `google_compute_network`/`subnetwork` |
| [006_firewall_rules](006_firewall_rules/task) | Firewall rules | `google_compute_firewall`, least privilege |
| [007_create_vm](007_create_vm/task) | Deploy a VM | `google_compute_instance`, startup scripts |
| [008_service_accounts_iam](008_service_accounts_iam/task) | Service accounts and IAM | least-privilege IAM |
| [009_secret_manager](009_secret_manager/task) | Secret Manager | sensitive variables, `google_secret_manager_secret` |
| [010_build_a_module](010_build_a_module/task) | Build a module | modules, `source`, reusability |
| [011_remote_state](011_remote_state/task) | Remote state | `backend "gcs"`, state locking |
| [012_configuration_drift](012_configuration_drift/task) | Configuration drift | `plan`, `apply -refresh-only`, state vs. reality |
| [013_import_existing_resources](013_import_existing_resources/task) | Migrating existing resources | `import` blocks, `-generate-config-out` |
| [014_capstone_module](014_capstone_module/task) | Capstone: build a module | modules, capstone project |

## General setup

See [000_exercise_setup](000_exercise_setup) for finding your project
ID, authenticating, and the full `init`/`plan`/`apply`/`destroy`
workflow. Always run `terraform destroy` before moving to the next
exercise so you aren't paying for resources you're done with.
