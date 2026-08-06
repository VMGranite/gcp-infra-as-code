# 006 — Firewall Rules

**Goal:** practice least-privilege network design with
`google_compute_firewall`.

## Tasks

1. Reuse the network from exercise 005 (copy it into this folder or
   rebuild it here).
2. Add a firewall rule that allows SSH (port 22) **only** from
   Google's Identity-Aware Proxy range: `35.235.240.0/20`. Use
   `target_tags` so it only applies to instances you explicitly tag.
3. Add a second firewall rule allowing HTTP (port 80) from
   `0.0.0.0/0`, also scoped with `target_tags`.
4. Run `terraform apply` and inspect the rules:
   ```bash
   gcloud compute firewall-rules list --format="table(name,sourceRanges.list(),allowed[].map().firewall_rule().list())"
   ```

## Success criteria

Two firewall rules exist, each scoped by tag rather than applying to
every instance in the network, and the SSH rule's source range is
restricted to the IAP range rather than the open internet.

## Discussion question

What would go wrong if you set `source_ranges = ["0.0.0.0/0"]` on the
SSH rule instead? Why does GCP's IAP range make that unnecessary?
