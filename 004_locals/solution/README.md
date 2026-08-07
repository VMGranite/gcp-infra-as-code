# 004 — Solution: Locals

## What this creates

- One `google_storage_bucket`, same as
  [003_variables_and_outputs](../003_variables_and_outputs) — the
  point of this exercise isn't the bucket, it's the two `locals` that
  compute its name and labels.

## Why

By exercise 003 you're comfortable with `variable`s — inputs supplied
from outside the config. `locals` solve a different problem: values
*derived* from other values, computed once, referenced everywhere. As
soon as you catch yourself writing the same expression — string
interpolation, a `merge()`, a conditional — more than once, that's the
signal to name it with a local instead.

## Why not just make `name_prefix` a variable with that default

You could, but it would be misleading: a `variable` with a `default`
still lets a caller override it with an unrelated value, and there'd
be nothing enforcing that `name_prefix` actually still equals
`"${var.project_id}-${var.region}"`. A `local` can't be overridden —
it's always exactly what its expression says, computed fresh from the
current values of `project_id` and `region` every time. Use a
variable for values that come from *outside* your config; use a local
for values *derived from* other values already inside it.

## Things worth noticing

- `locals` blocks aren't ordered relative to each other or to
  resources — Terraform figures out the dependency graph the same way
  it does for resources, from references, not from where something is
  written in the file.
- `merge()` here isn't strictly necessary for two labels — you could
  write one map literal — but it's the standard pattern once you have
  a "base" set of labels every resource should get, plus per-resource
  additions, and it scales to more resources without repeating the
  base labels at each one.
- If `var.environment` changes on a later `apply`, `local.common_labels`
  recomputes automatically — locals are never "stale," because
  they're not stored independently, they're just names for
  expressions evaluated at plan time.
