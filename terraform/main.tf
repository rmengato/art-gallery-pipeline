terraform {
  required_providers {
    kestra = {
      source = "kestra-io/kestra"
      version = "0.22.0"
    }
  }
}

provider "kestra" {
}

resource "kestra_flow" "from_bucket_to_staging" {
  namespace = "qr_art_gallery"
  flow_id        = "from_bucket_to_staging"
  content   = file("${path.module}/flows/qr_art_gallery.from_bucket_to_staging.yaml")
}

resource "kestra_flow" "from_met_api_to_bucket" {
  namespace = "qr_art_gallery"
  flow_id        = "from_met_api_to_bucket"
  content   = file("${path.module}/flows/qr_art_gallery.from_met_api_to_bucket.yaml")
}

resource "kestra_flow" "from_staging_to_transformed" {
  namespace = "qr_art_gallery"
  flow_id        = "from_staging_to_transformed"
  content   = file("${path.module}/flows/qr_art_gallery.from_staging_to_transformed.yaml")
}



resource "kestra_kv" "gcp_project_id" {
  namespace = "qr_art_gallery"
  key       = "GCP_PROJECT_ID"
  value     = var.gcp_project_id
}

resource "kestra_kv" "gcp_location" {
  namespace = "qr_art_gallery"
  key       = "GCP_LOCATION"
  value     = var.gcp_location
}

resource "kestra_kv" "gcp_bucket_name" {
  namespace = "qr_art_gallery"
  key       = "GCP_BUCKET_NAME"
  value     = var.gcp_bucket_name
}
