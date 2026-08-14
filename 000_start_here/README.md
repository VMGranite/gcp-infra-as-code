# 000 — Start Here

Do this once before starting the following exercises.

[Visit the Official Terraform + GCP Get Started Tutorial Here](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started)

## 1. Find your GCP project ID

Terraform needs to know exactly which GCP project to create resources
in — there's no default, and project IDs are globally unique, so
nobody can hand you one that "just works." Pick whichever of these
matches your setup:

- **If `gcloud` is already configured in your environment** (common
  in auto-provisioned sandbox/lab environments):
  ```bash
  gcloud config get-value project
  ```
- **To see every project you have access to:**
  ```bash
  gcloud projects list
  ```
  This prints `PROJECT_ID`, `NAME`, and `PROJECT_NUMBER`. You want the
  **ID** — it's not always the same as the display name, and it's
  different from the numeric project number.
- **In the GCP Console:** console.cloud.google.com → the project
  picker at the top of the page, or the "Project info" card on the
  Home/Dashboard page.
- **In a temporary/sandbox lab environment** (e.g. Qwiklabs / Google
  Cloud Skills Boost style): the assigned project ID is usually
  printed directly on the lab instructions panel when your
  environment is provisioned — often something like
  `qwiklabs-gcp-01-xxxxxxxx`.

Write it down — you'll need it in every exercise folder. If none of
the above turned up a project (e.g. `gcloud projects list` comes back
empty), go to step 1 to create one, then come back here.

Make sure to set your project in GCP as to not accidentally update the wrong project.
`gcloud config set project training-project-XX` 


## 2. Authenticate

Two separate logins are required, because they serve different tools:

```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
```

- `gcloud auth login` authenticates the `gcloud` CLI itself, so you
  can run `gcloud` commands (useful for verifying what Terraform
  created).
- `gcloud auth application-default login` writes **Application
  Default Credentials (ADC)** to a well-known local file. This is
  what Terraform's `google` provider actually reads — it doesn't use
  your `gcloud auth login` session. Skip this one and `terraform
  plan` will fail with a "could not find default credentials" error.
- `gcloud config set project` sets the default project for `gcloud`
  commands. It does **not** affect Terraform — Terraform only knows
  the project ID you put in the `.tf` files themselves (next step).

## 3. Put your project ID into an exercise

How you supply your project ID changes once, partway through the
course:

- **`001_connect_to_gcp` and `002_create_storage_bucket`** — before
  variables are introduced, the provider block just has a blank
  project field to fill in by hand:
  ```hcl
  provider "google" {
    project = "" # TODO: your project ID
    region  = "us-central1"
  }
  ```
  Replace the empty string with your real project ID from step 1.

- **`003_variables_and_outputs` onward** — every exercise from here
  on has a `variables.tf` with `project_id` (required, no default)
  and `region` (default `"us-central1"`) already declared, and the
  provider block already references `var.project_id`/`var.region`.
  You never edit the provider block itself again. Instead, each
  exercise folder has a `terraform.tfvars.example` — copy it to
  `terraform.tfvars` (gitignored, never committed) and fill in your
  real project ID:
  ```bash
  cp terraform.tfvars.example terraform.tfvars
  # edit terraform.tfvars and set project_id = "your-real-id"
  ```
  Every exercise folder is self-contained (see the note at the top of
  the [root README](../README.md)), so you'll repeat this two-line
  step in each new folder even though you just did it in the last
  one — that's expected, not a sign you missed something.

  You can also override a value for one command without touching the
  file, e.g. to try a different project temporarily:
  ```bash
  terraform plan -var="project_id=some-other-id"
  ```
  [005_variable_validation](../005_variable_validation) uses this
  `-var` override deliberately, to test bad input without disturbing
  the good values already sitting in `terraform.tfvars`.
  [015_secret_manager](../015_secret_manager) is the one exception in
  the other direction — its `secret_value` variable is never added to
  `terraform.tfvars` at all, because a secret shouldn't sit in a
  plaintext file even a gitignored one; that exercise's README
  explains why.

## 4. The Terraform workflow (repeat this in every exercise)

Run these from inside an exercise's `task/` (or `solution/`) folder:

```bash
terraform fmt        # auto-formats your .tf files to canonical style
terraform init        # downloads the google provider, sets up the working directory
terraform plan         # shows what would change — nothing is created yet
terraform apply        # actually creates the resources (this is what costs money/affects your project)
# ...verify your work, e.g. with gcloud or the GCP Console...
terraform destroy      # tears everything back down
```

- `fmt` is safe and non-destructive — it only rewrites whitespace and
  alignment in your `.tf` files to Terraform's canonical style. Get in
  the habit of running it before `plan`; it costs nothing and keeps
  every exercise's code consistent, which matters once more than one
  person is reading it.
- `init` is safe to re-run any time; it doesn't touch GCP resources.
- `plan` is read-only — always run it before `apply` so you know what
  you're about to create.
- `apply` will prompt you to type `yes` before it does anything.
- **Always run `terraform destroy` before moving to the next
  exercise.** Nothing here is designed to run continuously, and
  leaving resources up across exercises is how you end up paying for
  things you're done with.

## 5. Finding what you created in GCP

`terraform apply` tells you what it created, but it's worth actually
looking at resources in the Console or `gcloud` too — that's the
skill you'll use once you're not running Terraform yourself (e.g.
debugging something a teammate or a CI pipeline created).

- The Console always scopes what you see to **the currently selected
  project** (top-left project picker). If you don't see something you
  just created, check that first — it's the most common cause of
  "it's not there."
- The **search bar** at the top of the Console ("Search products and
  resources, docs, and more") can jump straight to a resource by
  name — faster than clicking through the left-hand navigation menu.
- The left-hand navigation menu (☰) groups services by category —
  Cloud Storage and Compute Engine are both under "Storage" /
  "Compute" respectively, and Networking/IAM have their own sections.
- Most resource types also have a `gcloud ... list` equivalent (e.g.
  `gcloud compute instances list`, `gcloud storage buckets list`) if
  you'd rather check from the terminal than the Console.

A couple of exercises give you a direct link for free — `012_create_vm`'s
solution outputs `vm_external_ip`, and `terraform output` after any
`apply` will print whatever that exercise defined, which is often
faster than navigating the Console at all.

## 6. Manual ("clickops") resources — [019_configuration_drift](../019_configuration_drift) and [021_import_existing_resources](../021_import_existing_resources)

Two exercises deliberately have you touch GCP outside of Terraform —
`019_configuration_drift` has you edit a resource by hand with
`gcloud`, and `021_import_existing_resources` has you create a bucket
by hand before Terraform ever knows about it. Both are intentional:
you can't learn how Terraform handles "someone changed this by hand"
without actually doing it. But it means Terraform doesn't know about
these resources yet, so `terraform destroy` won't reliably clean them
up.

- **Label every manually-created or manually-modified resource with
  `clickops_resource=true`** as you create/edit it, e.g.:
  ```bash
  gcloud storage buckets update gs://YOUR_BUCKET --update-labels=clickops_resource=true
  # or at creation time:
  gcloud storage buckets create gs://YOUR_BUCKET --labels=clickops_resource=true
  ```
  This makes anything you touched outside Terraform easy to spot in
  the Console (filter by label) instead of blending in with
  Terraform-managed resources.
- **Clean up depends on whether you finished the exercise:**
  - If a manually-created resource ends up successfully imported into
    Terraform (as in `021`), it's now Terraform-managed — a normal
    `terraform destroy` handles it like anything else.
  - If you stop partway — created something by hand but never
    imported it, or abandoned the exercise — Terraform still doesn't
    know it exists, and you must delete it yourself:
    ```bash
    gcloud storage buckets delete gs://YOUR_BUCKET
    ```
  - Either way, before moving on, sweep for anything you might have
    left behind:
    ```bash
    gcloud storage buckets list --filter="labels.clickops_resource=true"
    ```
    Delete anything that shows up here that isn't already covered by
    a `terraform destroy`.

## 7. `task/` vs `solution/`

Every exercise folder has both. Work in `task/` first — it has the
README with instructions and a `main.tf` with `TODO`s for you to
fill in. `solution/` is a complete, working version to check your
work against or unstick you if you're stuck, not something to copy
before you've tried.
