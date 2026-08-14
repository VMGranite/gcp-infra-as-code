# 011 — Dynamic Blocks and Conditionals

**Goal:** generate repeated nested blocks from a list instead of
writing each one by hand, and pick a value based on a condition
instead of hardcoding it.

[Visit the Official Terraform Dynamic Blocks Documentation Here](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks)

[Visit the Official Terraform Conditional Expressions Documentation Here](https://developer.hashicorp.com/terraform/language/expressions/conditionals)

## Setup

`variables.tf` already has `project_id`/`region` pre-filled, same as
every exercise since [003_variables_and_outputs](../003_variables_and_outputs).

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars and set project_id to your real project ID
```

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
