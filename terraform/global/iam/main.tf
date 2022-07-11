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
 
terraform {
  required_version = ">= 1.0.7"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "< 5.0, >= 2.12"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "< 5.0, >= 3.45"
    }
  }
}

provider "google" {
  project = var.project_id
}

/******************************************
	GCS Bucket configuration for Terraform State management
 *****************************************/

terraform {
  backend "gcs" {
    bucket = "cogility-terraform-state-us-wst4-01"   
    prefix = "global/iam"
  }
}

/******************************************
  Module for service_account
 *****************************************/

module "service_account" {
  source                  = "../../modules/iam/"
  project_id              = var.project_id
  service_account_name    = "cogility-gke-clustr-sa"
  role_id                 = "cogility_gke_clustr_role"
  service_account_address = module.service_account.email
  permissions             = ["iam.serviceAccounts.actAs","iam.serviceAccounts.get","iam.serviceAccounts.list","logging.logEntries.create","monitoring.metricDescriptors.create","monitoring.metricDescriptors.get","monitoring.metricDescriptors.list","monitoring.monitoredResourceDescriptors.get","monitoring.monitoredResourceDescriptors.list","monitoring.timeSeries.create","resourcemanager.projects.get",]
  project_roles           = ["projects/${var.project_id}/roles/cogility_gke_clustr_role", "roles/container.admin", "roles/artifactregistry.reader", "roles/compute.admin", "roles/compute.instanceAdmin", "roles/logging.logWriter", "roles/monitoring.metricWriter", "roles/monitoring.viewer", "roles/iam.serviceAccountUser", "roles/stackdriver.resourceMetadata.writer", "roles/iam.securityAdmin","roles/storage.admin","roles/iam.serviceAccountAdmin"]
}


# /******************************************
#   Outputs of service_accounts
#  *****************************************/

output "custom_role_name" {
  value = module.service_account.role_name
}

output "sa_email" {
  value = module.service_account.email
}