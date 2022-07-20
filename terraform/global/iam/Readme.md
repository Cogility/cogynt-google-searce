# Project IAM Service Account Module

This module makes it easy to create custom roles and Perform role bindings for IAM Service Accounts.

- Custom roles
- IAM Service Accounts
- Role bindings for IAM Service Accounts

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.7 |
| google | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 3.0 |

## Configure a Service Account

In order to execute this module you must have a Service Account with the
following project roles:

- [roles/iam.serviceAccountAdmin](https://cloud.google.com/iam/docs/understanding-roles)

## Enable APIs

In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- IAM API: iam.googleapis.com

## Usage
Basic usage of this module is as follows:

* Service Accounts

```hcl
module "service_account" {
  source                  = "../../modules/iam/"
  project_id              = var.project_id
  service_account_name    = "cogility-gke-clustr-sa"
  role_id                 = "cogility_gke_clustr_role"
  service_account_address = module.service_account.email
  permissions             = [""]
  project_roles           = [""]
}
```

* Provide the variables values to the modules from terraform.tfvars file.

```hcl
project_id    = "xxx"
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project | The ID of the project in which to provision resources | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| custom_role_name | Custom Role name |
| sa_email | Service account email |


* Then perform the following commands in the directory:

   `terraform init` to get the plugins

   `terraform plan` to see the infrastructure plan

   `terraform apply` to apply the infrastructure build

   `terraform destroy` to destroy the built infrastructure
