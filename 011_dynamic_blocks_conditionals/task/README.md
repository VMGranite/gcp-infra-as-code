# 011 — Dynamic Blocks and Conditionals

**Goal:** generate repeated nested blocks from a list instead of
writing each one by hand, and pick a value based on a condition
instead of hardcoding it.

[Visit the Official Terraform Dynamic Blocks Documentation Here](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks)

[Visit the Official Terraform Conditional Expressions Documentation Here](https://developer.hashicorp.com/terraform/language/expressions/conditionals)

## Why dynamic blocks, and why conditionals?

In [007_count_for_each](../007_count_for_each) you used `for_each` to
generate multiple *resources* from one block. A `dynamic` block solves
the same problem one level deeper: generating multiple *nested
blocks* — like `allow { }` inside a single `google_compute_firewall`
resource — from a list, instead of writing one `allow { }` per port by
hand. Without it, adding a port means editing the resource itself;
with it, adding a port means editing `var.allowed_ports`, and the
resource never changes. That distinction matters because the resource
block is the thing you review and diff carefully — the variable is
the thing you expect to change often.

Conditional expressions (`condition ? true_val : false_val`) solve a
different problem: picking one of two values for a single argument
based on some other value, without duplicating the whole resource
block for each case. Here, `source_ranges` needs to be the open
internet in `dev`/`staging` (so you can reach it while testing) but
locked to the IAP range in `prod` (see
[010_firewall_rules](../010_firewall_rules) for why that matters). A
conditional lets one resource block serve both cases — the
alternative would be an `if`/`else`-style duplication of the entire
resource per environment, which Terraform's declarative language
doesn't really support cleanly anyway.

## Setup

`variables.tf` already has `project_id`/`region` pre-filled — that
part goes back to [003_variables_and_outputs](../003_variables_and_outputs).
`terraform.tfvars` is already here too, committed with placeholder
values — just edit `project_id` to your real project ID (see 003's
README for why this file is committed instead of gitignored).

## Tasks

1. Reuse the network/subnet pattern from
   [008_create_vpc_network](../008_create_vpc_network) /
   [010_firewall_rules](../010_firewall_rules).
2. Define a variable `allowed_ports`:
   ```hcl
   variable "allowed_ports" {
     type = list(object({
       protocol = string
       ports    = list(string)
     }))
     default = [
       { protocol = "tcp", ports = ["22"] },
       { protocol = "tcp", ports = ["80", "443"] },
     ]
   }
   ```
3. Define **one** `google_compute_firewall` resource with a
   `dynamic "allow"` block that generates one `allow { }` block per
   entry in `var.allowed_ports`:
   ```hcl
   dynamic "allow" {
     for_each = var.allowed_ports
     content {
       protocol = allow.value.protocol
       ports    = allow.value.ports
     }
   }
   ```
4. Bring forward the validated `environment` variable from
   [005_variable_validation](../005_variable_validation) — string,
   default `"dev"`, with its `validation` block restricting it to
   `dev`/`staging`/`prod` — rather than declaring a fresh, unvalidated
   one. Set the firewall rule's `source_ranges` with a conditional
   expression: narrow to the IAP range (`35.235.240.0/20`) in
   `"prod"`, and `0.0.0.0/0` otherwise.
5. Run `terraform apply`, then confirm the rule has **two** allowed
   entries:
   ```bash
   gcloud compute firewall-rules describe YOUR_RULE_NAME --format="value(allowed)"
   ```
6. Change `environment` to `"prod"` and run `terraform plan` — confirm
   only `source_ranges` changes.

## Success criteria

One firewall rule, generated from one resource block, has two
`allow` entries sourced from a list — and its `source_ranges` changes
based on `var.environment` without touching the resource block
itself.

## Discussion question

You could get the same two `allow` entries by writing two `allow { }`
blocks directly in the resource, with no `dynamic` at all. At what
point does hardcoding each block stop being simpler than a `dynamic`
block — and why does that threshold matter less once the list comes
from a variable instead of being fixed in your head while you write
the code?
