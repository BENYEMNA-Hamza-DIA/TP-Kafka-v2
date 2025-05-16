## Déploiement sans Github Action
#variable "google_credentials" {
#  description = "Path to the GCP credentials JSON file"
#  type        = string
#}

#locals {
#  credentials_file_path = "${path.module}/gcp-key.json"
#}

#resource "local_file" "gcp_key" {
#  content  = var.google_credentials
#  filename = local.credentials_file_path
#}
##
##

## Deploiement avec Github Action
##
variable "google_credentials" {
  description = "GCP credentials JSON"
  type        = string
}

variable "gcp_project" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region where resources will be deployed"
  type        = string
  default     = "europe-west9"
}

variable "gcp_zone" {
  description = "GCP zone for the VM"
  type        = string
  default     = "europe-west1-b"
# europe-west9-a = France / europe-west1-b = Belgique
}

variable "vm_name" {
  description = "Name of the Kafka VM"
  type        = string
  default     = "kafka-instance"
}

variable "machine_type" {
  description = "Machine type for the VM"
  type        = string
  default     = "e2-standard-2"
}

variable "os_image" {
  description = "Operating system image"
  type        = string
  default     = "debian-cloud/debian-12"
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 30
}

variable "allowed_ports" {
  description = "List of allowed ports for firewall"
  type        = list(string)
  default     = ["8080", "9090", "3000", "9092", "9095", "9093", "9094", "2181", "9308"]
}


variable "ssh_pub_key" {
  description = "Clé publique SSH pour l'accès à la VM"
  type        = string
}
