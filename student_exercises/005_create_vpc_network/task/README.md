# 005 — A Custom VPC Network

**Goal:** learn that GCP networking is explicit — nothing exists
until you define it.

## Tasks

1. Enable the Compute Engine API if you haven't already:
   ```bash
   gcloud services enable compute.googleapis.com --project YOUR_PROJECT_ID
   ```
   or manage it with a `google_project_service` resource.
2. Define a `google_compute_network` with `auto_create_subnetworks =
   false`.
3. Define a `google_compute_subnetwork` inside that network with a
   `/24` CIDR range in a region of your choice.
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
