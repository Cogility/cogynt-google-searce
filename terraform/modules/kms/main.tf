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
  required_version = ">= 1.0.0"
}


resource "google_kms_key_ring" "keyring" {
  name     = var.key_ring_name
  location = var.location
  project  = var.project
}

resource "google_kms_crypto_key" "key" {
  name            = var.key_name
  key_ring        = google_kms_key_ring.keyring.id
  labels          = var.labels
  purpose         = var.purpose
  rotation_period = var.key_rotation_period
  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  lifecycle {
    prevent_destroy = false
  }
}

# /******************************************
#   Outputs of KMS
#  *****************************************/


output "keyring_id" {
  value       = resource.google_kms_key_ring.keyring.id
  description = "ID of KMS key ring"
}

output "key_id" {
  value       = resource.google_kms_crypto_key.key.id
  description = "ID of KMS key"
}
