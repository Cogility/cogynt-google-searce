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

##################
# Snapshot Policy Creation
##################
resource "google_compute_resource_policy" "snapshot_policy" {
  name = var.policy_name
  snapshot_schedule_policy {
    schedule {
      hourly_schedule {
        hours_in_cycle = 23
        start_time     = var.utc_time # In UTC
      }
    }
    retention_policy {
      max_retention_days    = var.retention_days
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
    snapshot_properties {
      storage_locations = [var.storage_location]
    }
  }
}

/**************
  Outputs
 **************/

output "self_link" {
  value       = google_compute_resource_policy.snapshot_policy.self_link
  description = "policy self link"
}

output "policy_name" {
  value       = var.policy_name
  description = "policy self link"
}
