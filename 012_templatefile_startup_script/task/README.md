# 012 — templatefile() for a Startup Script

**Goal:** generate a VM's startup script from a template file with
variables, instead of a raw heredoc string baked into `main.tf`.

## Tasks

1. Reuse the VM/network/firewall pattern from
   [011_create_vm](../011_create_vm).
2. Create `templates/startup.sh.tftpl`:
   ```bash
   #!/bin/bash
   apt-get update
   apt-get install -y apache2
   echo "${welcome_message}" > /var/www/html/index.html
   ```
3. Define a variable `welcome_message` (string, default
   `"Hello from Terraform templatefile()!"`).
4. In the `google_compute_instance` resource, render the template
   instead of writing the script inline:
   ```hcl
   metadata_startup_script = templatefile("${path.module}/templates/startup.sh.tftpl", {
     welcome_message = var.welcome_message
   })
   ```
5. Run `terraform apply`, wait a minute for the startup script to run,
   then `curl http://<external-ip>` and confirm your custom message
   appears.
6. Change `welcome_message` and run `terraform plan` — what does
   Terraform propose to change, and why?

## Success criteria

The rendered page shows your custom `welcome_message`, and you can
explain what part of the VM resource changes when you edit the
template versus when you edit the variable's value.

## Discussion question

`templatefile()` reads the file and renders it **at plan time**, on
your machine — the VM never sees `startup.sh.tftpl` itself, only the
fully-rendered string in `metadata_startup_script`. Given that, if you
change `welcome_message` and re-`apply` against an **already-running**
VM, does the running VM's web page update automatically? Why or why
not?
