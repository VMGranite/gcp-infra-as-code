# 011 — Deploy a VM

**Goal:** bring networking (005/006) and compute together by
deploying a real VM with a startup script.

## Tasks

1. Rebuild (or copy in) the network, subnet, and firewall rules from
   005/006.
2. Define a `google_compute_instance`:
   - `machine_type = "e2-micro"` (Always Free tier eligible in
     `us-central1`, `us-west1`, `us-east1`)
   - boot disk image: `debian-cloud/debian-12`
   - attach it to your subnet, with an `access_config {}` block for a
     public IP
   - tag it `["ssh", "http-server"]` so the firewall rules apply
3. Add a `metadata_startup_script` that installs and starts a
   basic web server, e.g.:
   ```bash
   #!/bin/bash
   apt-get update
   apt-get install -y apache2
   ```
4. Run `terraform apply`, then visit `http://<external-ip>` in a
   browser — give the startup script a minute to run first.
5. SSH in via IAP to confirm access:
   ```bash
   gcloud compute ssh example-vm --zone=YOUR_ZONE --tunnel-through-iap
   ```

## Success criteria

You can reach the Apache default page over HTTP, and SSH in through
IAP (not a public SSH port).

## Cost note

`e2-micro` is free-tier eligible in the three regions above under
normal usage. Always run `terraform destroy` when you're done.
