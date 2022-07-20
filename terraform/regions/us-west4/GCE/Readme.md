# Google Management GCE VM Module

This module makes it easy to create a GCE VM.

- Disk Policy
- GCE VM

## Usage

Basic usage of this module is as follows:

* Disk Policy

```hcl
module "disk_policy_creation" {
  source = "../../../modules/compute_engine/disk_snapshot_policy"

  policy_name      = "cogility-disk-policy"
  utc_time         = "06:00"
  retention_days   = "7"
  storage_location = "us"
}
```

* Linux VM

```hcl
module "linux_vm" {
  source = "../../../modules/compute_engine/linux_vm/"

  project_id = var.project_id
  region     = var.region

  machine_name        = "cogility-mgnt-vm"
  machine_type        = "e2-medium"
  machine_zone        = "us-west4-b"
  instance_labels     = {
    purpose    = "private-gke"
  }
  vm_deletion_protect = false
  instance_image_selflink = "projects/confidential-vm-images/global/images/ubuntu-2004-focal-v20220404"

  network            = "cogility-main-01-vpc"
  subnetwork         = "cogility-pvt-us-wst4-subnet"
  network_tags       = ["allow-iap"]
  internal_ip        = "10.200.0.5"
  enable_external_ip = false

  boot_disk_info       = {
    disk_size_gb = "30"
    disk_type    = "pd-standard"
  }
  snapshot_policy_name = module.disk_policy_creation.policy_name

  service_account = "cogility-gke-clustr-sa@cogynt.iam.gserviceaccount.com"
}
```

* Provide the variables values to the modules from terraform.tfvars file.

```hcl
project_id  = "xxx"
region      = "us-west4"

```

* Then perform the following commands in the directory:

   `terraform init` to get the plugins

   `terraform plan` to see the infrastructure plan

   `terraform apply` to apply the infrastructure build

   `terraform destroy` to destroy the built infrastructure
