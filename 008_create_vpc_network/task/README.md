# 008 — A Custom VPC Network

**Goal:** learn that GCP networking is explicit — nothing exists
until you define it.

[Visit the Official google_compute_network Resource Documentation Here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network)

[Visit the Official google_compute_subnetwork Resource Documentation Here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork)

## What's a VPC?

A **VPC (Virtual Private Cloud)** is a private network that lives
inside GCP, isolated from every other customer's network and, by
default, from the public internet. It's the thing every other
resource in this course from here on actually plugs into: a VM's
network card, a firewall rule, a load balancer — all of them belong
to some VPC network. Nothing in GCP talks to anything else over the
network unless it's on a VPC you've defined and explicitly allowed
(that's this exercise's Goal, and the point of
[010_firewall_rules](../010_firewall_rules) right after it).

A VPC network on its own has no IP addresses to hand out — that's
what a **subnetwork (subnet)** is for: a specific range of IP
addresses, tied to one region, carved out of the network for
resources in that region to actually use. This exercise creates one
network and one subnet inside it; a real VPC usually has several
subnets, one per region you operate in.

That IP range is written in **CIDR notation** — e.g. `10.0.1.0/24`.
The part before the `/` is a starting IP address; the number after it
says how many addresses that range covers by fixing that many bits of
the address (a `/24` fixes the first 24 bits, leaving 8 free, which
works out to 256 addresses: `10.0.1.0` through `10.0.1.255`). You
don't need to be able to compute this by hand — `/24` is a common,
safe default size for a small subnet, and
[009_builtin_functions](../009_builtin_functions) shows you a
function that carves these up for you instead of hand-computing them.

## Setup

`variables.tf` already has `project_id`/`region` pre-filled — that
part goes back to [003_variables_and_outputs](../003_variables_and_outputs).
`terraform.tfvars` is already here too, committed with placeholder
values — just edit `project_id` to your real project ID (see 003's
README for why this file is committed instead of gitignored). Every
exercise folder is self-contained, so you'll edit a fresh copy of
this file in each new folder even though you just did it in the last
one — that's expected, not a sign you missed something.

## Tasks

1. Enable the Compute Engine API if you haven't already. GCP groups
   its functionality into APIs/services (Compute Engine for
   VMs/networking, Secret Manager for secrets, etc.), and each one
   has to be turned on per-project before you can create anything
   that uses it — a new project doesn't have them all on by default:
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
