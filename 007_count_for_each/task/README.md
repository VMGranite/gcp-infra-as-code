# 007 — count / for_each

**Goal:** create multiple similar resources from a single block,
instead of copy-pasting a resource once per item.

## Tasks

1. Define a variable `environments` — a set of strings, default
   `["dev", "staging", "prod"]`.
2. Define **one** `google_storage_bucket` resource using
   `for_each = var.environments`, naming each bucket
   `"${var.project_id}-${each.value}-bucket"`.
3. Add an output that maps each environment to its bucket's URL:
   ```hcl
   output "bucket_urls" {
     value = { for env, b in google_storage_bucket.this : env => b.url }
   }
   ```
4. Run `terraform apply` and confirm **three** buckets were created
   from that one resource block.
5. Now, as a thought experiment (don't actually do this to your real
   config), imagine rewriting the same resource with
   `count = length(var.environments)` and `name =
   "${var.project_id}-${var.environments[count.index]}-bucket"`
   instead. Run `terraform plan` after removing `"staging"` from the
   middle of the list in the `for_each` version, then imagine doing
   the same removal in the `count` version — what would `terraform
   plan` show differently between the two?

## Success criteria

Three buckets exist, one per environment, all created from a single
`resource` block — and you can explain why removing an item from the
*middle* of the list is safe with `for_each` but risky with `count`.

## Discussion question

`for_each` requires a **set or map** (each key must be unique and
stable), while `count` just needs a number. What does that constraint
buy you when it comes to how Terraform identifies "resource #2" after
your list of inputs changes?
