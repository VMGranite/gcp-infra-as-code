# 005 — Variable Validation

**Goal:** make bad input fail fast, with a clear message, before
Terraform ever talks to GCP.

[Visit the Official Terraform Input Variables Documentation Here](https://developer.hashicorp.com/terraform/language/values/variables)
(see the "Custom Validation Rules" section)

## Tasks

1. Define a variable `environment` (string) with a `validation` block
   that only allows `"dev"`, `"staging"`, or `"prod"`:
   ```hcl
   variable "environment" {
     type = string

     validation {
       condition     = contains(["dev", "staging", "prod"], var.environment)
       error_message = "environment must be one of: dev, staging, prod."
     }
   }
   ```
2. Define a variable `retention_days` (number) with a validation block
   requiring it to be a positive integer.
3. Define a `google_storage_bucket` that uses `var.environment` in its
   labels and `var.retention_days` in a `lifecycle_rule`.
4. Run `terraform plan -var="environment=qa" -var="retention_days=30"`
   — don't fix anything yet, just read the error.
5. Now run `terraform plan -var="environment=dev" -var="retention_days=-5"`
   — read that error too.
6. Fix both values and confirm `terraform plan` succeeds.

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
