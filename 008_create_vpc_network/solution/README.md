# 008 — Solution: A Custom VPC Network

## What this creates

- **`google_project_service`** — enables the Compute Engine API.
- **`google_compute_network`** — a custom-mode VPC (`auto_create_subnetworks
  = false`).
- **`google_compute_subnetwork`** — one subnet, one region, one CIDR
  range you chose explicitly.

## Why enable the API as a resource

New GCP projects don't have every API pre-enabled — Compute Engine's
API usually isn't on by default. You *could* run
`gcloud services enable compute.googleapis.com` by hand once, but
encoding it as a `google_project_service` resource means it's part of
the same reproducible `apply` as everything else — anyone (or any CI
pipeline) running this config from a brand-new project gets the API
turned on automatically, instead of hitting a cryptic "API not
enabled" error and having to go figure out why.

## Why a custom network instead of the default one

Every new GCP project comes with a "default" VPC that auto-creates a
subnet in *every* region and ships with permissive default firewall
rules. That's convenient for poking around in the console, but it's
the opposite of what you want in a real, Terraform-managed
environment: resources you didn't ask for, in regions you're not
using, with rules you didn't write. `auto_create_subnetworks = false`
plus an explicit subnetwork is how you get exactly the network
footprint you intended and nothing else — a pattern you'll want by
default in production configs.

## Things worth noticing

- The `depends_on = [google_project_service.compute]` on the network
  resource is necessary, not decorative: enabling an API is
  eventually consistent, and nothing about *referencing* the API
  enablement resource would otherwise tell Terraform to wait for it,
  since the network resource doesn't use any of the API-enablement
  resource's output values.
- `10.0.1.0/24` gives you 256 IP addresses in that subnet — plenty for
  learning, but real designs think about CIDR sizing up front since
  resizing a subnet later is disruptive.
