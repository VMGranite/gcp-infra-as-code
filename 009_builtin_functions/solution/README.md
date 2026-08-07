# 009 — Solution: Built-in Functions

## What this creates

- A custom VPC network with three subnets (`dev`, `staging`, `prod`),
  each carved out of `10.0.0.0/16` by `cidrsubnet()` and named with
  `format()`.
- A bucket holding a `network-manifest.json` object built with
  `jsonencode()`.

## Why `cidrsubnet()` instead of typing each range

Hand-computing `10.0.1.0/24`, `10.0.2.0/24`, and so on works until it
doesn't — someone eventually fat-fingers an overlapping range, or the
parent block changes and every subnet needs recalculating by hand.
`cidrsubnet(prefix, newbits, netnum)` does the arithmetic: give it the
parent block, how many extra bits to carve out (`8` more bits on a
`/16` gives `/24`s), and which subnet number you want, and it returns
a correct, non-overlapping range every time. Change `network_cidr`
from `10.0.0.0/16` to `10.1.0.0/16` and every subnet recomputes
correctly on the next `apply` — nothing to manually redo.

## Why `format()` here instead of string interpolation

`"${var.project_id}-${each.value}-subnet"` would work identically —
`format()` isn't doing anything interpolation can't. It's included
here mainly so you've seen it: `format()` becomes worth reaching for
once you need padding, numeric formatting (`%05d`), or a format
string that's itself a variable — none of which plain interpolation
can express. For a simple concatenation like this one, either is
fine; this exercise uses `format()` so the syntax is familiar before
you hit a case where you actually need it.

## Why `jsonencode()` instead of building a JSON string by hand

Hand-building JSON with string interpolation is a quoting minefield —
forget to escape a value with a `"` in it, and you've produced
invalid JSON that only fails once something tries to parse it.
`jsonencode()` takes an ordinary Terraform value (here, a map mixing
a string and a nested map) and always produces valid JSON, correctly
escaped, regardless of what's in the values. This is the standard way
to generate JSON config files, API request bodies, or structured
metadata from Terraform.

## Things worth noticing

- `index(var.subnet_names, each.value)` turns a name back into its
  position in the list — which is exactly the `count`-style
  positional thinking that [007_count_for_each](../007_count_for_each)
  warned about. Insert a new name in the middle of `subnet_names` and
  every subnet *after* it gets a new `netnum`, hence a new CIDR range,
  hence Terraform proposes to destroy and recreate it — even though
  you're using `for_each`. `for_each` protects resource *identity*
  from reordering; it does nothing to protect a *value you derive
  from position* within that resource. Appending new names to the end
  of the list avoids this; inserting in the middle doesn't.
- The manifest's `subnets` value is itself a `for` expression over a
  `for_each` resource — the same "flatten a for_each resource into a
  plain map" pattern from
  [007_count_for_each](../007_count_for_each)'s output.
- `terraform console` (not covered elsewhere in this course) is a
  fast way to experiment with functions like these outside a full
  `plan`/`apply` cycle — worth trying:
  `echo 'cidrsubnet("10.0.0.0/16", 8, 2)' | terraform console`.
