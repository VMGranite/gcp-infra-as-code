project_id = "your-gcp-project-id"
region     = "us-central1"

# secret_value is NOT here on purpose. Unlike project_id/region above,
# this file is committed — pass secrets with -var or
# TF_VAR_secret_value instead, never save them to any file. See
# README.md.
