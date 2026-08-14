# 004 — Locals

**Goal:** stop repeating yourself. Compute a value once with `locals`
and reuse it, instead of re-typing the same expression everywhere.

[Visit the Official Terraform Locals Tutorial Here](https://developer.hashicorp.com/terraform/tutorials/configuration-language/locals)

## Setup

This exercise reuses the pattern from
[003_variables_and_outputs](../003_variables_and_outputs): a
`variables.tf` for inputs and a `terraform.tfvars` (never committed)
for your real values. `variables.tf` already has `project_id` and
`region` declared for you — that part doesn't change from exercise
to exercise, so from here on you'll find it pre-filled and only the
new variables for that exercise's concept left as `TODO`s.

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars and set project_id to your real project ID
```

## Tasks

1. Reuse the bucket pattern from
   [003_variables_and_outputs](../003_variables_and_outputs): the same
   `project_id`/`region` variables and provider block, one
   `google_storage_bucket`. (This exercise doesn't reuse `bucket_name`
   itself — you're about to replace it with a computed local.)
2. In `variables.tf`, add `variable "environment"` (string, default
   `"dev"`) — this is the `TODO` already sitting in that file. No
   validation yet; that's the whole point of
   [005_variable_validation](../005_variable_validation), which adds
   a `validation` block to this exact variable rather than inventing
   a new one.
3. Add `environment = "dev"` to your `terraform.tfvars`.
4. Add a `locals` block that computes a `name_prefix`, e.g.:
   ```hcl
   locals {
     name_prefix = "${var.project_id}-${var.region}"
   }
   ```
5. Use `local.name_prefix` to build the bucket's name instead of a
   variable directly — e.g. `"${local.name_prefix}-bucket"`.
6. Add a second local, `common_labels`, that merges a fixed label
   with one derived from a variable:
   ```hcl
   locals {
     common_labels = merge(
       { managed_by = "terraform" },
       { environment = var.environment }
     )
   }
   ```
7. Apply `local.common_labels` to the bucket's `labels` argument.
8. Run `terraform apply` and confirm the bucket's name and labels
   reflect both locals.

## Success criteria

Neither `local.name_prefix` nor `local.common_labels` is computed
more than once in your code — every place that needs that value
references the local, not a repeated expression.

## Discussion question

`locals` and `variable`s can look similar at a glance — both are
named values you reference elsewhere in the config. What's the actual
difference in where each one's value *comes from*, and why does that
mean you'd never write `variable "name_prefix" { default =
"${var.project_id}-${var.region}" } `?
