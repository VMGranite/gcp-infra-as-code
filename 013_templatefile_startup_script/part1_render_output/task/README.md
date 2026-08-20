# 013 (Part 1) — Render a Template to Output

**Goal:** see `templatefile()` do its one job — fill in a template's
blanks from a map of values — with nothing else going on: no VM, no
waiting, no network, no GCP resource at all.

[Visit the Official Terraform templatefile() Function Documentation Here](https://developer.hashicorp.com/terraform/language/functions/templatefile)

## Why start here, before touching a VM

`templatefile(path, vars)` reads a file from disk and renders it with
the variables you pass in — like a mail-merge template: the file has
blanks (`${name}`), and the second argument is what you'd type in to
fill them. That's the whole function. [Part 2](../../part2_vm_startup_script)
puts it to use inside a VM's startup script, but a VM adds boot time,
an external IP, and `curl` on top of the one new idea — none of which
is `templatefile()` itself. This part strips all of that away so you
can watch the function work in isolation first.

## Setup

`variables.tf` already has `your_name` pre-filled with a default —
edit `terraform.tfvars` if you want to render your own name instead.
Notice there's no `project_id` or `region` here: this part creates no
GCP resource, so it needs no GCP provider at all.

## Tasks

1. Create `templates/welcome.tftpl`:
   ```
   Hello, ${name}! Welcome to Terraform templates.
   ```
2. Add an output that renders it:
   ```hcl
   output "rendered_message" {
     value = templatefile("${path.module}/templates/welcome.tftpl", {
       name = var.your_name
     })
   }
   ```
3. Run `terraform apply` and confirm the rendered message prints in
   the output.
4. Change `your_name` in `terraform.tfvars` and run `terraform apply`
   again — confirm the output updates immediately.

## Success criteria

The `rendered_message` output shows your custom name, and re-running
`apply` after changing the variable updates it right away — no
waiting, nothing else to check.

## Discussion question

You just watched `rendered_message` change the instant you edited
`your_name` and reran `apply`. Hold onto that observation for
[Part 2](../../part2_vm_startup_script) — you'll change a similarly-named
variable there, and the result will **not** update that instantly, even
though `templatefile()` is doing the exact same kind of rendering in
both cases. What's different about where each rendered value ends up?
