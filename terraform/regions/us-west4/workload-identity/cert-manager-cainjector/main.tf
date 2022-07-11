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
  Versions Details 
 *****************************************/

terraform {
  required_version = ">= 0.13.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.39.0, < 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-kubernetes-engine:workload-identity/v20.0.0"
  }
}

provider "google" {}

terraform {
  backend "gcs" {
    bucket = "cogility-terraform-state-us-wst4-01"   
    prefix = "workload-identity/cert-manager-cainjector"  
  }
}

/******************************************
  Workload Identity Details 
 *****************************************/

module "workload_identities_cert_manager_cainjector" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity" 
  project_id          = var.project_id
  name                = "cert-manager-cainjector"
  namespace           = "kube-system"
  use_existing_k8s_sa = true
  k8s_sa_name         = "cert-manager-cainjector"
  use_existing_gcp_sa = true
  annotate_k8s_sa     = false
}


/******************************************
  Output Details 
 *****************************************/

output "workload_identities" {
  description = "The details of the created Workload Identity creation for existing GSA and KSA."
  value       = module.workload_identities_cert_manager_cainjector
}

