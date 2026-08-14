# 008 — A Custom VPC Network

**Goal:** learn that GCP networking is explicit — nothing exists
until you define it.

[Visit the Official google_compute_network Resource Documentation Here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network)

## Setup

`variables.tf` already has `project_id`/`region` pre-filled, same as
every exercise since [003_variables_and_outputs](../003_variables_and_outputs).
Every exercise folder is self-contained, so this repeats even though
you did it in the last exercise too — it's a cheap two-line step, and
it means this folder still works if you come back to it on its own.

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars and set project_id to your real project ID
```

## Tasks

1. Enable the Compute Engine API if you haven't already:
   ```bash
   gcloud services enable compute.googleapis.com --project YOUR_PROJECT_ID
   ```
   or manage it with a `google_project_service` resource referencing
   `var.project_id` (the way the rest of this config references your
   project — see the provider block already in `main.tf`).
2. Define a `google_compute_network` with `auto_create_subnetworks =
   false`.
3. Define a `google_compute_subnetwork` inside that network with a
   `/24` CIDR range. Use `var.region`, the same variable your provider
   block already uses — don't hand-type a region string here.
4. Run `terraform apply`, then verify:
   ```bash
   gcloud compute networks subnets list --network=YOUR_NETWORK_NAME
   ```

## Success criteria

Your custom network and subnet show up in `gcloud`, and the subnet's
`network` field correctly references your network (not a hardcoded
name or ID).

## Discussion question

What's the difference between `auto_create_subnetworks = true` and
`false`? Why might `false` be the better default for a real project?
