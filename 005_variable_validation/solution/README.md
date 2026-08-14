# 005 — Solution: Variable Validation

## What this creates

- One `google_storage_bucket`, labeled by `var.environment` and
  retained per `var.retention_days` — the same shape as earlier
  exercises. What's new is the `validation` block added to the same
  `environment` variable from
  [004_locals](../004_locals) (not a new one), plus a fresh
  `retention_days` variable with its own validation.

## Why

Without validation, a typo like `environment = "qa"` doesn't fail
until something downstream notices — maybe a label mismatch nobody
catches, maybe a conditional elsewhere in a larger config that
silently takes the wrong branch because it only checked for `"dev"`
or `"prod"`. `validation` blocks move that failure to the earliest
possible point — `terraform plan`, before any API call — and let you
write the error message yourself instead of whatever generic failure
would've happened three steps later.

## Why this matters more as configs grow

In a two-resource config like this one, a bad `environment` value is
easy to spot by eye. In a real config with dozens of resources
referencing `var.environment` in different ways — some in names, some
in conditionals, some in IAM bindings — a typo becomes much harder to
trace back to its source. `validation` blocks don't get harder to
write as the config grows; they get more valuable.

## Things worth noticing

- The `condition` expression can only reference the variable it's
  validating (`var.environment` inside `environment`'s own block) —
  it can't depend on other variables or resources, because validation
  runs before Terraform knows anything else about the plan.
- `contains(["dev", "staging", "prod"], var.environment)` is a common
  pattern for "must be one of these exact values" — worth knowing by
  sight, since it comes up constantly.
- This is a client-side check only — it catches typos and structural
  mistakes, not "is this a value GCP will actually accept." A
  syntactically valid but nonsensical value (a real region string
  that doesn't have the resource type available) still won't be
  caught until GCP rejects it during `apply`.
- This is the first exercise where `terraform.tfvars` comes
  pre-committed with placeholder values instead of you writing it
  from scratch, purely to save typing once the file itself is
  familiar — see [003_variables_and_outputs](../../003_variables_and_outputs)
  for why it's committed at all rather than gitignored.
