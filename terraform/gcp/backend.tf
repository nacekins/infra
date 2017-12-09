terraform {
    backend "gcs" {
        bucket = "traincat-terraform"
        prefix = "gcp"
    }
}

