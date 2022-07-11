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
 
provider "google" {
  project = var.project
}



terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = "~> 3.0"
  }
}

/******************************************
	GCS Bucket configuration for Terraform State management
 *****************************************/

terraform {
  backend "gcs" {
    bucket = "cogility-terraform-state-us-wst4-01"  
    prefix = "global/kms"
  }
}


module "kms" {
  source                = "../../modules/kms/"
  key_ring_name         = "cogility-kms-key-ring-us-west4"
  location              = var.location
  project               = var.project
  key_name              = "cogility-key-us-west4"
  labels = {
    "env" = "cogynt"
  }
  purpose              = "ENCRYPT_DECRYPT"
  key_rotation_period  = "100000s"
  key_algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
  key_protection_level = "SOFTWARE"
}


# /******************************************
#   Outputs of KMS
#  *****************************************/


output "keyring_id" {
  value       = module.kms.keyring_id
  description = "ID of KMS key ring"
}

output "key_id" {
  value       = module.kms.key_id
  description = "ID of KMS key"
}