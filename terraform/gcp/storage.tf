resource "google_storage_bucket" "config" {
    name          = "${var.bucket-config-name}"
    storage_class = "REGIONAL"
    location      = "${var.bucket-config-location}"

    versioning {
        enabled = true
    }
}

