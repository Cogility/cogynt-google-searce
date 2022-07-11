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
 
resource "google_project_iam_custom_role" "my_custom_role" {

  project     = var.project_id
  role_id     = var.role_id
  title       = var.role_id
  stage       = "GA"
  permissions = var.permissions
}

resource "google_project_iam_member" "project_iam_member" {
  for_each = toset(var.project_roles)
  project  = var.project_id
  role     = each.key
  member   = "serviceAccount:${var.service_account_address}"
}

resource "google_service_account" "service_account" {
  account_id   = var.service_account_name
  display_name = var.service_account_name
  project      = var.project_id
}


# /******************************************
#   Outputs of service_accounts
#  *****************************************/

output "role_name" {
  value = google_project_iam_custom_role.my_custom_role.role_id
}

output "roles" {
  value       = google_project_iam_member.project_iam_member
  description = "Project roles."
}

output "project_id" {
  value       = var.project_id
  description = "Project id."
}

output "email" {
  value = google_service_account.service_account.email
}

output "name" {
  value = google_service_account.service_account.name
}