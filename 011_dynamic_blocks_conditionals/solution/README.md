# 011 — Solution: Dynamic Blocks and Conditionals

## What this creates

- The network/subnet pattern from
  [008_create_vpc_network](../008_create_vpc_network).
- **One** `google_compute_firewall` rule with two `allow` entries,
  generated from `var.allowed_ports` via a `dynamic` block, and
  `source_ranges` chosen by a conditional expression on
  `var.environment`.

## Why dynamic blocks

`allow { }` is a *nested block*, not an argument — you can't build it
with a plain `for` expression the way you would a list or map value.
`dynamic "allow"` is what lets you generate nested blocks from a
collection: for each item in `var.allowed_ports`, it stamps out one
`allow { }` block using `allow.value` to reference that item's
fields. Without it, adding a third port range to `allowed_ports`
would mean going back into the resource and hand-adding a third
`allow { }` block to match — exactly the kind of code/data
duplication `for_each` on a resource avoids for whole resources, and
`dynamic` avoids for blocks *within* one resource.

## Why the conditional instead of two separate resources

```hcl
source_ranges = var.environment == "prod" ? ["35.235.240.0/20"] : ["0.0.0.0/0"]
```

This is the same underlying idea as
[010_firewall_rules](../010_firewall_rules)'s IAP-only SSH rule, made
data-driven: instead of two separate hardcoded firewall resources
(one loose for dev, one strict for prod), one resource's behavior
changes based on an input. The ternary (`condition ? a : b`) is the
simplest form of conditional logic in Terraform — reach for it when a
single value needs to differ based on something else, before reaching
for `count = condition ? 1 : 0` (a much heavier tool, used to
conditionally create or omit an entire resource).

## Things worth noticing

- Inside `dynamic "allow" { ... }`, the loop variable is named
  `allow` (matching the block label) unless you rename it with
  `iterator`. `allow.value` refers to the current item from
  `var.allowed_ports`; `allow.key` would be its index (or map key, if
  iterating a map instead of a list).
- This resource has no `target_tags`, unlike
  [010_firewall_rules](../010_firewall_rules) — worth noticing what's
  a deliberate simplification for this exercise (fewer moving parts,
  to keep focus on `dynamic`/conditionals) versus what you'd want in
  a real rule.
- The conditional is evaluated at plan time, from the value of
  `var.environment` you pass in — nothing here reacts automatically
  if some *other* condition changes later. Terraform conditionals
  aren't runtime logic; they're resolved once, per `plan`/`apply`.
