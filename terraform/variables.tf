variable "project_id" {
  description = "ID du projet GCP"
  type        = string
}

variable "region" {
  description = "Région GCP"
  type        = string
  default     = "us-central1"
}

variable "gitlab_repo" {
  description = "URL du dépôt GitLab"
  type        = string
}
