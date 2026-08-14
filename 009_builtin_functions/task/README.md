# 009 — Built-in Functions

**Goal:** stop hand-computing values Terraform can derive for you.
Use `cidrsubnet()` to carve subnets out of one CIDR block instead of
typing each one, `format()` for consistent resource names, and
`jsonencode()` to build structured data safely.

[Visit the Official Terraform Built-in Functions Documentation Here](https://developer.hashicorp.com/terraform/language/functions)

## Setup

`variables.tf` already has `project_id`/`region` pre-filled (that
part goes back to [003_variables_and_outputs](../003_variables_and_outputs)),
plus `network_cidr` (default `"10.0.0.0/16"`, the parent block you'll
carve subnets out of) and `subnet_names` (default `["dev", "staging",
"prod"]`) already defined — those two aren't new variable-declaration
practice, they're just the input this exercise's functions operate on.
`terraform.tfvars` is already here too, committed with placeholder
values — just edit `project_id` to your real project ID.

## Tasks

1. Create one `google_compute_network` (custom mode) and, using
   `for_each` over `var.subnet_names`, one `google_compute_subnetwork`
   per name — but instead of writing each `ip_cidr_range` by hand, compute
   it with `cidrsubnet()`:
   ```hcl
   ip_cidr_range = cidrsubnet(var.network_cidr, 8, index(var.subnet_names, each.value))
   ```
   This carves `10.0.0.0/16` into `/24` blocks — `10.0.0.0/24`,
   `10.0.1.0/24`, `10.0.2.0/24` — one per subnet, without you
   computing a single one by hand. (If the CIDR notation itself —
   what the `/16` and `/24` mean — is unfamiliar, see
   [008_create_vpc_network](../008_create_vpc_network)'s "What's a
   VPC?" section first; `network_cidr` here is exactly the same kind
   of range you hand-typed there, just bigger.)

   **What it's for:** in [008](../008_create_vpc_network) you picked
   one `/24` range and typed it by hand — fine for one subnet, but
   this exercise needs three, and they can't overlap. Hand-typing
   `10.0.0.0/24`, `10.0.1.0/24`, `10.0.2.0/24` yourself means doing
   binary arithmetic in your head and hoping you don't fat-finger a
   range that overlaps another one — and if `network_cidr` ever
   changes (`10.0.0.0/16` → `10.1.0.0/16`), every hand-typed subnet
   is now wrong and has to be redone by hand too. `cidrsubnet()`
   computes a subnet range *from* the parent block instead, so it's
   always correct and non-overlapping, and it updates itself
   automatically if `network_cidr` ever changes. That's the same
   "derive it instead of typing it" idea as `local.name_prefix` back
   in [004_locals](../004_locals), just applied to IP math instead of
   a string.

   `cidrsubnet(prefix, newbits, netnum)` takes three arguments:
   - **`prefix`** — the CIDR block you're carving up. Here,
     `var.network_cidr` (`10.0.0.0/16`).
   - **`newbits`** — how many *more* bits to fix, shrinking the range.
     `8` here means `/16 + 8 = /24`: each resulting subnet is a `/24`.
     (Bigger `newbits` = smaller subnets, more of them possible.)
   - **`netnum`** — *which* of the resulting `/24` subnets you want,
     as a plain number starting at `0`. `netnum = 0` gives you
     `10.0.0.0/24`, `netnum = 1` gives you `10.0.1.0/24`, and so on —
     it's counting subnets within the parent range, not an IP address
     itself. That's why step 1's call wraps
     `index(var.subnet_names, each.value)` around it: `index()` turns
     `"staging"`'s position in the list (`1`) into the `netnum` that
     picks the second `/24` block.
2. Name each subnet with `format()` instead of string interpolation:
   ```hcl
   name = format("%s-%s-subnet", var.project_id, each.value)
   ```
3. Add a `google_storage_bucket_object` that uploads a small JSON
   config file built with `jsonencode()`:
   ```hcl
   resource "google_storage_bucket_object" "network_manifest" {
     name    = "network-manifest.json"
     bucket  = google_storage_bucket.this.name
     content = jsonencode({
       network_cidr = var.network_cidr
       subnets      = { for name, s in google_compute_subnetwork.this : name => s.ip_cidr_range }
     })
   }
   ```
   (Reuse a `google_storage_bucket` from an earlier exercise — the
   bucket itself isn't the point here.)
4. Run `terraform apply`, then confirm the subnets got distinct,
   non-overlapping CIDR ranges:
   ```bash
   gcloud compute networks subnets list --format="table(name,ipCidrRange)"
   ```
5. Download and read the uploaded manifest to confirm `jsonencode()`
   produced valid JSON:
   ```bash
   gcloud storage cat gs://YOUR_BUCKET/network-manifest.json
   ```

## Success criteria

Three subnets exist with distinct `/24` ranges computed entirely by
`cidrsubnet()` — you never typed `10.0.1.0/24` anywhere — and the
uploaded manifest is valid, parseable JSON built by `jsonencode()`,
not a hand-written string.

## Discussion question

`cidrsubnet(prefix, newbits, netnum)` takes a *number* (`netnum`), not
a name, to select which subnet you get. This exercise uses
`index(var.subnet_names, each.value)` to turn `"staging"` into a
number. What happens to every subnet *after* `"staging"` in the list
if you insert a new name in the middle of `var.subnet_names` and
re-apply — and how does that compare to the `for_each` vs. `count`
lesson from [007_count_for_each](../007_count_for_each)?
