provider "kestra" {
  url      = env("KESTRA_URL")
  username = env("KESTRA_USERNAME")
  password = env("KESTRA_PASSWORD")
}

resource "kestra_flow" "from_bucket_to_staging" {
  namespace = "qr_art_gallery"
  id        = "from_bucket_to_staging"
  content   = file("${path.module}/flows/qr_art_gallery.from_bucket_to_staging.yaml")
}

resource "kestra_flow" "from_met_api_to_bucket" {
  namespace = "qr_art_gallery"
  id        = "from_met_api_to_bucket"
  content   = file("${path.module}/flows/qr_art_gallery.from_met_api_to_bucket.yaml")
}

resource "kestra_flow" "from_staging_to_transformed" {
  namespace = "qr_art_gallery"
  id        = "from_staging_to_transformed"
  content   = file("${path.module}/flows/qr_art_gallery.from_staging_to_transformed.yaml")
}
