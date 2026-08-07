# 014 — Service Accounts and IAM

**Goal:** practice least-privilege IAM instead of relying on the
default compute service account.

[Visit the Official google_service_account Resource Documentation Here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account)

## Tasks

1. Define a `google_service_account` for your VM, e.g. `vm-runner`
   with a descriptive `display_name`.
2. Grant it only the roles it actually needs — for example
   `roles/storage.objectViewer` on a specific bucket via
   `google_storage_bucket_iam_member`, **not**
   `roles/storage.admin` on the whole project.
3. Update the `google_compute_instance` from exercise 012 to use this
   service account instead of the default one:
   ```hcl
   service_account {
     email  = google_service_account.vm_runner.email
     scopes = ["cloud-platform"]
   }
   ```
4. Run `terraform apply` and confirm from inside the VM that it can
   read from the bucket but not, say, list other projects' resources.

## Success criteria

The VM authenticates as your custom service account (check
`gcloud compute instances describe` for `serviceAccounts[].email`),
and that service account's permissions are scoped to exactly one
bucket, not the whole project.

## Discussion question

Why is `google_storage_bucket_iam_member` (resource-level) preferable
to `google_project_iam_member` (project-level) here? What's the
blast radius difference if the VM's credentials were ever leaked?
