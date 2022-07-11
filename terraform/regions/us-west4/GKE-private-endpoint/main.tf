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
 
# /***********************
# 	Versions Details
#  ***********************/

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

provider "google" {}
provider "google-beta" {}


# /**********************************************************
# 	GCS Bucket configuration for Terraform State management
#  **********************************************************/

 
terraform {
  backend "gcs" {
    bucket = "cogility-terraform-state-us-wst4-01"
    prefix = "regions/us-west4/gke_cluster"
  }
}


data "google_project" "project" {
  project_id = var.project_id
}


# /*************************
# 	Cluster configurations
#  *************************/

module "gke_private_cluster" {
  source                                = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                            = var.project_id
  name                                  = "cogility-us-wst4-cluster-01"
  region                                = var.region
  network                               = "cogility-main-01-vpc"
  subnetwork                            = "cogility-pvt-us-wst4-subnet"
  ip_range_pods                         = "cogility-pvt-us-wst4-subnet-pod"
  ip_range_services                     = "cogility-pvt-us-wst4-subnet-svc"
  regional                              = true
  create_service_account                = false
  http_load_balancing                   = true
  network_policy                        = true
  horizontal_pod_autoscaling            = true
  enable_private_endpoint               = true
  enable_private_nodes                  = true
  deploy_using_private_endpoint         = true
  master_ipv4_cidr_block                = "10.2.0.0/28"
  remove_default_node_pool              = true
  initial_node_count                    = 0
  service_account                       = "cogility-gke-clustr-sa@cogynt.iam.gserviceaccount.com"
  master_authorized_networks            = [
    {
      cidr_block   = "10.200.0.0/16"
      display_name = "vpc-ip-range"
    }
  ]

  cluster_resource_labels               = {
    "env" : "cogynt"
  }
  kubernetes_version                    = "1.22.8-gke.200"
  node_pools = [
    {
      name                           = "worker"
      machine_type                   = "n2-standard-8"
      image_type                     = "UBUNTU_CONTAINERD"
      node_locations                 = "us-west4-b"
      min_count                      = 3
      max_count                      = 20
      disk_size_gb                   = 100
      enable_autoscaling             = true
      max_pods_per_node              = 110
      disk_type                      = "pd-standard"
      gke_cluster_min_master_version = "1.22.8-gke.200"
      auto_upgrade                   = false
      auto_repair                    = false
      boot_disk_kms_key              = "projects/cogynt/locations/us-west4/keyRings/cogility-kms-key-ring-us-west4/cryptoKeys/cogility-key-us-west4"
    },
    {
      name                           = "imply-data"
      machine_type                   = "n2-standard-8"
      image_type                     = "UBUNTU_CONTAINERD"
      node_locations                 = "us-west4-b"
      min_count                      = 3
      max_count                      = 3
      disk_size_gb                   = 50
      enable_autoscaling             = true
      max_pods_per_node              = 110
      disk_type                      = "pd-standard"
      gke_cluster_min_master_version = "1.22.8-gke.200"
      auto_upgrade                   = false
      auto_repair                    = false
      boot_disk_kms_key              = "projects/cogynt/locations/us-west4/keyRings/cogility-kms-key-ring-us-west4/cryptoKeys/cogility-key-us-west4"
    },
    {
      name                           = "storage"
      machine_type                   = "n2-standard-8"
      image_type                     = "UBUNTU_CONTAINERD"
      node_locations                 = "us-west4-b"
      min_count                      = 6
      max_count                      = 6
      disk_size_gb                   = 50
      enable_autoscaling             = true
      max_pods_per_node              = 110
      disk_type                      = "pd-standard"
      gke_cluster_min_master_version = "1.22.8-gke.200"
      auto_upgrade                   = false
      auto_repair                    = false
      boot_disk_kms_key              = "projects/cogynt/locations/us-west4/keyRings/cogility-kms-key-ring-us-west4/cryptoKeys/cogility-key-us-west4"
    }
  ]
  node_pools_labels = {
    all = {}

    worker = {
      "px/enabled"         = "false",
      "k8s.cogynt.io/node" = "worker",
    }

    storage = {
      "px/enabled"         = "true",
      "k8s.cogynt.io/node" = "storage",
    }

    imply-data = {
      "px/enabled"         = "false",
      "k8s.cogynt.io/node" = "imply-data",
    }
  }
}


# /*************************
# 	Cluster output
#  *************************/

output "gke_cluster" {
  value       = module.gke_private_cluster.name
  description = "Name of the cluster"
}

output "node_pools" {
  value       = module.gke_private_cluster.node_pools_names
  description = "Name of the node pools"
}