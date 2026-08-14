# 001 — Connect Terraform to GCP

**Goal:** get `terraform plan` talking to your GCP project without
creating any billable resources.

[Visit the Official Terraform + GCP Get Started Tutorial Here](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started)

[Visit the Official google_project Data Source Documentation Here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/google_project)

## Tasks

1. Authenticate the gcloud CLI:
   ```bash
   gcloud auth application-default login
   gcloud config set project YOUR_PROJECT_ID
   ```
2. Open `main.tf`. Everything you'll write in this course is made of
   blocks shaped like this:
   ```hcl
   keyword "label" {
     argument = value
   }
   ```
   `provider "google" { }`, already partly in the file, is one of
   these — `provider` is the keyword, `"google"` is the label (which
   provider you're configuring), and everything you add inside `{ }`
   is an `argument = value` pair. Fill in `project` (and optionally
   `region`/`zone`) pointed at your project ID from
   [000_start_here](../../000_start_here).
3. Add a `data "google_project" "this"` data source that looks up
   your own project. Notice it takes *two* labels instead of one —
   `"google_project"` (the type, fixed by the provider — you can't
   invent this) and `"this"` (a name you make up, used only to refer
   back to it later in this file). Every `resource` block you write
   starting in the next exercise follows this same two-label shape.
   An empty `{ }` body is valid here — see the Hints below for why.
4. Add an `output` block that prints the project's display name from
   that data source:
   ```hcl
   output "some_name" {
     value = some.reference.here
   }
   ```
   Its `value` needs to point at the data source you just created,
   using `data.google_project.this.<attribute>` — that
   `TYPE.NAME.ATTRIBUTE` shape is how you'll reference *any* block by
   its two labels for the rest of this course, whether it's a data
   source, a resource, or (later on) a module.
5. Run `terraform init` then `terraform plan` — no resources should
   be created (plan should show 0 to add), but the output should
   resolve correctly.

## Success criteria

`terraform plan` succeeds and shows the correct project name in the
planned output — proof Terraform can authenticate to and read from
your GCP project.

## Hints

- `data` blocks don't create anything; they read existing state from
  the provider. This is a safe way to test a connection.
- Not every argument inside `{ }` is required — the docs page linked
  above lists this data source's **Argument Reference**, and every
  entry on it happens to be optional, which is why an empty `{ }`
  body is a complete, valid block here. Leaving it empty just tells
  Terraform to use the provider's default project.
- That same docs page lists this data source's **Attributes
  Reference** near the bottom, separately from the Argument
  Reference — that's where you'll find the exact attribute name for
  the output in step 4 (it's not called `display_name`).
- If `plan` fails with a permissions error, check that your account
  has at least `roles/viewer` on the project.
