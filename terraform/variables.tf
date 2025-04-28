variable "gcp_creds" {
  description = "GCP service account key (JSON)"
  type        = string
  sensitive   = true
}

variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
  default     = "de-zoomcamp-rmengato"
}

variable "gcp_location" {
  description = "GCP location (e.g., US)"
  type        = string
  default     = "europe-west2"
}

variable "gcp_bucket_name" {
  description = "GCP bucket name"
  type        = string
  default     = "qr_art_gallery_zoom_bucket"
}
