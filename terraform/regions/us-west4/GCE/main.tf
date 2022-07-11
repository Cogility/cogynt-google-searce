/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/******************************************
  Linux instance versions
 *****************************************/ 
terraform {
  required_version = ">= 1.0"
  required_providers {
    google = "~> 3.0"
  }
}

/******************************************
  Linux instance providers
 *****************************************/
provider "google" {
  project = var.project_id
  region  = var.region
}

/******************************************
  Linux instance backend
 *****************************************/
terraform {
  backend "gcs" {
    bucket = "cogility-terraform-state-us-wst4-01"
    prefix = "regions/us-west4/gce"
  }
}

/******************************************
  Linux instance module
 *****************************************/

module "disk_policy_creation" {
  source = "../../../modules/compute_engine/disk_snapshot_policy"

  /* global */
  policy_name      = "cogility-disk-policy"
  utc_time         = "06:00"
  retention_days   = "7"
  storage_location = "us"
}

module "linux_vm" {
  source = "../../../modules/compute_engine/linux_vm/"

  /* global */
  project_id = var.project_id
  region     = var.region

  /* machine details */
  machine_name        = "cogility-mgnt-vm"
  machine_type        = "e2-medium"
  machine_zone        = "us-west4-b"
  instance_labels     = {
    purpose    = "private-gke"
  }
  vm_deletion_protect = false
  instance_image_selflink = "projects/confidential-vm-images/global/images/ubuntu-2004-focal-v20220404"

  /* network details */
  network            = "cogility-main-01-vpc"
  subnetwork         = "cogility-pvt-us-wst4-subnet"
  network_tags       = ["allow-iap"]
  internal_ip        = "10.200.0.5"
  enable_external_ip = false

  /* disk details */
  boot_disk_info       = {
    disk_size_gb = "30"
    disk_type    = "pd-standard"
  }
  snapshot_policy_name = module.disk_policy_creation.policy_name

  /* service account */
  service_account = "cogility-gke-clustr-sa@cogynt.iam.gserviceaccount.com"
}


/******************************************
  Linux instance outputs
 *****************************************/
output "linux_instance_name_vm01" {
  description = "Name of Instance"
  value       = module.linux_vm.name
}
