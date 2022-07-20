# Google Cloud Terraform Modules

## Requirements
### Installed Software
- [Terraform](https://www.terraform.io/downloads.html)
- [gcloud](https://cloud.google.com/sdk/gcloud/)


## Authenticate to gcloud sdk

You can authenticate using GCP IAM using following steps.

- Open the local terminal and use your organization email address for authentication

```
gcloud auth login
gcloud auth application-default login
gcloud config set account <project-id>
```

**Note:** To impersonate the Service Account, the IAM User should have Service Account Token Creator role attached.

## Use following commands to execute terraform code with impersonated credentials:

```gcloud config set auth/impersonate_service_account [SA_FULL_EMAIL]```

Setting the environment variable:

```export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=[SA_FULL_EMAIL]```

Verify the configuration

```gcloud config list```

## Features

- Modularized structure.
- Terraform backend state maintained in GCS bucket with versioning enabled.
- Isolation between the terraform tfstate files for the GCP resources for reducing impact.
- Terraform tfvars used for passing varibales
- Consistent structure and naming convention

## Backend configuration

If you are working on a team, then it's best to store the Terraform state file remotely so that many people can access it. In order to set up Terraform to store state remotely, you need two things: an GCS bucket to store the state file in and a Terraform GCS backend resource.

```hcl
terraform {
  backend "gcs" {
    bucket = "example-gcs"
    prefix = "<path-of-the-terraform-files>" // e.g "global/networking/vpc_subnets"
  }
}
```

## The Terraform resources will consists of following structure

```
├── README.md                 // Description of the module and what it should be used for.
├── main.tf                   // The primary entrypoint for terraform resources.
├── variables.tf              // It contain the declarations for variables.
├── outputs.tf                // It contain the declarations for outputs.
├── providers.tf              // To specify infrastructure vendors.
├── versions.tf               // To specify terraform versions.
├── backend.tf                // To create terraform backend state configuration.
├── terraform.tfvars          // The file to pass the terraform variables values.
```
## References

- [Using Terraform with Google Cloud](https://cloud.google.com/docs/terraform)
- [Get Started - Google Cloud](https://learn.hashicorp.com/collections/terraform/gcp-get-started)
- [Getting started with Terraform on Google Cloud](https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform)
- [Getting Started with the Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started)
