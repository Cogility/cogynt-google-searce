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

/**************************************************************
	GCS Bucket configuration for Terraform State management
 *************************************************************/

terraform {
  backend "gcs" {
    bucket = "cogility-terraform-state-us-wst4-01"   
    prefix = "global/applications-sa"
  }
}


# /******************************************
#   Modules of service_accounts
#  *****************************************/

module "service_account_autopilot" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "autopilot"
  service_account_address   = module.service_account_autopilot.email
  project_roles             = ["projects/${var.project_id}/roles/cogility_gke_clustr_role"]
}

module "service_account_cert_manager" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "cert-manager"
  service_account_address   = module.service_account_cert_manager.email
  project_roles             = ["projects/${var.project_id}/roles/cogility_gke_clustr_role"]
}

module "service_account_cert_manager_cainjector" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "cert-manager-cainjector"
  service_account_address   = module.service_account_cert_manager_cainjector.email
  project_roles             = ["projects/${var.project_id}/roles/cogility_gke_clustr_role"]
}

module "service_account_cert_manager_webhook" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "cert-manager-webhook"
  service_account_address   = module.service_account_cert_manager_webhook.email
  project_roles             = ["projects/${var.project_id}/roles/cogility_gke_clustr_role"]
}


module "service_account_portworx" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "portworx"
  service_account_address   = module.service_account_portworx.email
  project_roles             = ["roles/iam.serviceAccountUser","roles/compute.admin","roles/compute.instanceAdmin","roles/storage.admin"]
}

module "service_account_px_csi" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "px-csi"
  service_account_address   = module.service_account_px_csi.email
  project_roles             = ["projects/${var.project_id}/roles/cogility_gke_clustr_role"]
}

module "service_account_px_prometheus" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "px-prometheus"
  service_account_address   = module.service_account_px_prometheus.email
  project_roles             = ["projects/${var.project_id}/roles/cogility_gke_clustr_role"]
}

module "service_account_px_prometheus_operator" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "px-prometheus-operator"
  service_account_address   = module.service_account_px_prometheus_operator.email
  project_roles             = ["projects/${var.project_id}/roles/cogility_gke_clustr_role"]
}


module "service_account_stork" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "stork-sa"
  service_account_address   = module.service_account_stork.email
  project_roles             = ["projects/${var.project_id}/roles/cogility_gke_clustr_role"]
}

module "service_account_stork_scheduler" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "stork-scheduler"
  service_account_address   = module.service_account_stork_scheduler.email
  project_roles             = ["projects/${var.project_id}/roles/cogility_gke_clustr_role"]
}

module "service_account_projectcontour" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "projectcontour"
  service_account_address   = module.service_account_projectcontour.email
  project_roles             = ["projects/${var.project_id}/roles/cogility_gke_clustr_role"]
}

module "service_account_loki_cogynt" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "cogynt-loki"
  service_account_address   = module.service_account_loki_cogynt.email
  project_roles             = ["roles/logging.logWriter","roles/monitoring.metricWriter","roles/monitoring.viewer","roles/stackdriver.resourceMetadata.writer"]
}

module "service_account_dashboard" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "k8s-dashboard"
  service_account_address   = module.service_account_dashboard.email
  project_roles             = ["roles/logging.logWriter","roles/monitoring.metricWriter","roles/monitoring.viewer","roles/stackdriver.resourceMetadata.writer"]
}

module "service_account_cogynt" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "cogynt"
  service_account_address   = module.service_account_cogynt.email
  project_roles             = ["roles/logging.logWriter","roles/monitoring.metricWriter"]
}

module "service_account_linkerd" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "linkerd"
  service_account_address   = module.service_account_linkerd.email
  project_roles             = ["roles/logging.logWriter","roles/monitoring.metricWriter","roles/monitoring.viewer","roles/stackdriver.resourceMetadata.writer"]
}

module "service_account_linkerd_viz" {
  source                    = "../../modules/applications_sa"
  project_id                = var.project_id
  service_account_name      = "linkerd-viz"
  service_account_address   = module.service_account_linkerd_viz.email
  project_roles             = ["roles/logging.logWriter","roles/monitoring.metricWriter","roles/monitoring.viewer","roles/stackdriver.resourceMetadata.writer"]
}

# /******************************************
#   Outputs of service_accounts
#  *****************************************/

output "autopilot" {
  value = module.service_account_autopilot.email
}

output "cert_manager" {
  value = module.service_account_cert_manager.email
}

output "cert_manager_cainjector" {
  value = module.service_account_cert_manager_cainjector.email
}

output "cert_manager_webhook" {
  value = module.service_account_cert_manager_webhook.email
}

output "portworx" {
  value = module.service_account_portworx.email
}

output "px_csi" {
  value = module.service_account_px_csi.email
}

output "px_prometheus" {
  value = module.service_account_px_prometheus.email
}

output "px_prometheus_operator" {
  value = module.service_account_px_prometheus_operator.email
}

output "stork" {
  value = module.service_account_stork.email
}

output "stork_scheduler" {
  value = module.service_account_stork_scheduler.email
}

output "projectcontour" {
  value = module.service_account_projectcontour.email
}

output "loki_cogynt" {
  value = module.service_account_loki_cogynt.email
}

output "dashboard" {
  value = module.service_account_dashboard.email
}

output "cogynt" {
  value = module.service_account_cogynt.email
}


output "linkerd" {
  value = module.service_account_linkerd.email
}

output "linkerd_viz" {
  value = module.service_account_linkerd_viz.email
}