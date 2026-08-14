# 005 — Variable Validation

**Goal:** make bad input fail fast, with a clear message, before
Terraform ever talks to GCP.

[Visit the Official Terraform Input Variables Documentation Here](https://developer.hashicorp.com/terraform/language/values/variables)
(see the "Custom Validation Rules" section)

## Setup

`variables.tf` has `project_id`/`region` pre-filled, same as every
exercise since [003_variables_and_outputs](../003_variables_and_outputs).
What's new starting here: this folder ships a `terraform.tfvars`
already committed, with placeholder values — edit it instead of
writing one from scratch:

```
project_id  = "your-gcp-project-id"  # TODO: replace with your project ID
region      = "us-central1"
environment = "dev"
```

Add `retention_days = 30` to it once you've defined that variable in
step 2 below.

## Tasks

1. In `variables.tf`, bring forward the `environment` variable you
   defined in [004_locals](../004_locals) (string, default `"dev"`)
   and add a `validation` block to it — don't declare a second,
   unrelated `environment` variable:
   ```hcl
   variable "environment" {
     type    = string
     default = "dev"

     validation {
       condition     = contains(["dev", "staging", "prod"], var.environment)
       error_message = "environment must be one of: dev, staging, prod."
     }
   }
   ```
2. Define a variable `retention_days` (number, default `30`) with a
   validation block requiring it to be a positive integer. Add
   `retention_days = 30` to your `terraform.tfvars`.
3. Define a `google_storage_bucket` that uses `var.environment` in its
   labels and `var.retention_days` in a `lifecycle_rule`.
4. Run `terraform plan -var="environment=qa" -var="retention_days=30"`
   — don't fix anything yet, just read the error. `-var` here
   temporarily overrides whatever's in your `terraform.tfvars` for
   this one command only; it doesn't edit the file. That's exactly
   why it's the right tool for testing a bad value on purpose — you
   get to try garbage input without touching the good value you
   already have saved.
5. Now run `terraform plan -var="environment=dev" -var="retention_days=-5"`
   — read that error too.
6. Run `terraform plan` with no `-var` flags at all and confirm it
   succeeds using the good values already sitting in
   `terraform.tfvars`.

## Success criteria

Both invalid values in steps 4 and 5 produce an immediate, specific
error message — naming which variable is wrong and why — without
Terraform ever attempting to contact the Google Cloud API.

## Discussion question

If you removed both `validation` blocks, an invalid `environment`
value would still eventually cause *some* kind of failure (a
mismatched label somewhere, or downstream logic that assumed one of
three environments). Why is failing at `terraform plan`, with a
message you wrote yourself, better than whatever would happen without
the validation block?
