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
   computing a single one by hand.
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
