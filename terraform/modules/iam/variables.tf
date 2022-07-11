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
 

variable "project_id" {
  description = "Project id"
  type        = string
}


variable "role_id" {
  description = "The camel case role id to use for this role."
}

variable "permissions" {
  description = "The names of the permissions this role grants when bound in an IAM policy. "
}

variable "service_account_address" {
  description = "Service account address"
  type        = string
}


variable "project_roles" {
  description = "List of IAM roles"
  type        = list(string)
}

variable "service_account_name" {
  description = "The account id that is used to generate the service account email address and a stable unique id"
}

