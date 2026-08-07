# 022 — Solution: Workspaces

## What this creates

- One `google_storage_bucket` resource — but applied once per
  workspace, it produces one **independent** bucket per workspace,
  each with its own state.

## Why workspaces are a different mechanism than modules

[017_build_a_module](../017_build_a_module) and
[023_capstone_module](../023_capstone_module) get multiple
environments by calling the *same code* multiple times, all within
**one** state file, in **one** `main.tf`. Workspaces get multiple
environments by keeping the *same code*, applied against **multiple,
independent state files** — `terraform.workspace` is just a string
Terraform injects into your config so resources can vary by which
state file is currently active.

Locally, you can see this directly:

```bash
ls terraform.tfstate.d/
# dev/  staging/
```

Each workspace's `terraform.tfstate` lives in its own directory,
completely separate from the others.

## Why that matters: blast radius and visibility

This is the real tradeoff, and it's the point of the discussion
question. With the module approach, `terraform plan` shows you
**both** `dev` and `staging` together — you can see the full picture
of what's about to change across every environment in one command.
With workspaces, `terraform plan` only ever shows you the *currently
selected* workspace — there's no single command that shows you `dev`
and `staging` together, because they're not in the same state.

That has a sharp edge: nothing in your terminal prompt tells you
which workspace is active by default. Running `terraform apply` after
forgetting you switched to `staging` an hour ago applies against
`staging`, not `dev` — silently, with no diff against the workspace
you *thought* you were targeting, because Terraform only ever knows
about one workspace's state at a time.

## When workspaces are still the right call

Despite that risk, workspaces are lighter-weight than a module for
genuinely identical environments that only differ by name/small
config — no extra `modules/` directory, no `source` argument, just
`terraform workspace new`. They fit best for short-lived,
throwaway environments (a personal dev sandbox, a PR preview
environment) where the blast-radius risk matters less than the setup
cost of a proper module.

## Things worth noticing

- `terraform.workspace` is a special built-in reference — not a
  variable, not a local, available in any `.tf` file with no
  declaration needed.
- `terraform workspace delete` refuses to delete a workspace that
  still has resources tracked in its state — you have to `destroy`
  first, which is why the task's cleanup steps do both, per
  workspace, before deleting either.
- If you'd used the `018_remote_state`-style GCS backend here instead
  of local state, workspaces would still work the same way — the
  backend just stores each workspace's state under a different key
  in the same bucket instead of a different local directory.
