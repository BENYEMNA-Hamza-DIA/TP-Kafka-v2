variable "google_credentials" {
  description = "Path to the GCP credentials JSON file"
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
  default     = "europe-west9-a"
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