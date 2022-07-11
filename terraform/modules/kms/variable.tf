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
 
variable "key_ring_name" {
  description = "Keyring name."
  type        = string
  default     = null
}

# cf https://cloud.google.com/kms/docs/locations
variable "location" {
  description = "Location for the keyring."
  type        = string
  default     = null
}

variable "project" {
  description = "Project id where the keyring will be created."
  type        = string
  default     = null
}

variable "key_name" {
  description = "Key names."
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels, provided as a map"
  type        = map(string)
  default     = {}
}

variable "purpose" {
  description = "Labels, provided as a map"
  type        = string
  default     = null
}

variable "key_rotation_period" {
  description = "Set the rotation period of keys."
  type        = string
  default     = null
}

variable "key_algorithm" {
  description = "The algorithm to use when creating a version based on this template. See the https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm for possible inputs."
  type        = string
  default     = null
}

variable "key_protection_level" {
  description = "The protection level to use when creating a version based on this template. Default value: \"SOFTWARE\" Possible values: [\"SOFTWARE\", \"HSM\"]"
  type        = string
  default     = null
}

