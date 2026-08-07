# 004 — Locals

**Goal:** stop repeating yourself. Compute a value once with `locals`
and reuse it, instead of re-typing the same expression everywhere.

## Tasks

1. Reuse the bucket from
   [003_variables_and_outputs](../003_variables_and_outputs) as your
   starting point: `project_id`, `region`, and `bucket_name`
   variables, one `google_storage_bucket`.
2. Add a `locals` block that computes a `name_prefix`, e.g.:
   ```hcl
   locals {
     name_prefix = "${var.project_id}-${var.region}"
   }
   ```
3. Use `local.name_prefix` to build the bucket's name instead of
   `var.bucket_name` directly — e.g.
   `"${local.name_prefix}-bucket"`.
4. Add a second local, `common_labels`, that merges a fixed label
   with one derived from a variable:
   ```hcl
   locals {
     common_labels = merge(
       { managed_by = "terraform" },
       { environment = var.environment }
     )
   }
   ```
5. Apply `local.common_labels` to the bucket's `labels` argument.
6. Run `terraform apply` and confirm the bucket's name and labels
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
