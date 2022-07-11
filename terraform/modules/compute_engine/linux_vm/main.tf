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

#########
# Locals
#########
locals {
  external_ip_add = var.enable_external_ip ? 1 : 0
  access_config   = local.external_ip_add != 0 ? [true] : []
  boot_disk_name  = google_compute_disk.boot_gce_disk.name
}

######################################
# Google Compute VM Boot Disk Creation
######################################
resource "google_compute_disk" "boot_gce_disk" {
  name  = "${var.machine_name}-boot-disk"
  size  = var.boot_disk_info["disk_size_gb"]
  type  = var.boot_disk_info["disk_type"]
  zone  = var.machine_zone
  image = var.instance_image_selflink

  labels = merge(
    var.disk_labels,
    tomap({
  a = "type"
  c = "boot"
})
  )
  physical_block_size_bytes = 4096
}

# #########################
# Google Static Internal IP
# #########################
resource "google_compute_address" "static_internal_ip_address" {
  name         = "${var.machine_name}-int-ip"
  address_type = "INTERNAL"
  address      = var.internal_ip
  subnetwork   = var.subnetwork
  region       = var.region
  lifecycle {
    prevent_destroy = false
  }
}

# #########################
# Google Static External IP
# #########################
resource "google_compute_address" "static_external_ip_address" {
  count        = local.external_ip_add
  name         = "${var.machine_name}-ext-ip"
  address_type = "EXTERNAL"
  region       = var.region
  lifecycle {
    prevent_destroy = false
  }
}

###################
# Google Compute VM
###################
resource "google_compute_instance" "gce_vm" {
  name         = var.machine_name
  machine_type = var.machine_type
  zone         = var.machine_zone

  allow_stopping_for_update = true
  deletion_protection       = var.vm_deletion_protect

  tags = var.network_tags

  boot_disk {
    auto_delete = false
    source      = google_compute_disk.boot_gce_disk.id
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    network_ip = google_compute_address.static_internal_ip_address.address

    dynamic "access_config" {
      for_each = local.access_config
      content {
        nat_ip       = google_compute_address.static_external_ip_address[0].address
        network_tier = "PREMIUM"
      }
    }
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }

  labels = var.instance_labels

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.service_account
    scopes = ["cloud-platform"]
  }

  
  # service_account = var.service_account

  metadata = var.metadata

}

###############################################
# Snapshot Policy Attachment for Boot Disks
###############################################
resource "google_compute_disk_resource_policy_attachment" "boot_diskpolicy_attach" {
  name = var.snapshot_policy_name
  disk = local.boot_disk_name
  zone = var.machine_zone
}


/******************************************
  Linux instance outputs
 *****************************************/

output "name" {
  description = "Name of Instance"
  value       = google_compute_instance.gce_vm.name
}

output "compute_instance_id" {
  description = "Compute instance id"
  value       = google_compute_instance.gce_vm.id
}

output "machine_zone" {
  description = "Compute instance zone"
  value       = var.machine_zone
}
