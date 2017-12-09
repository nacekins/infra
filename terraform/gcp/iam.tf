resource "google_service_account" "publisher" {
    account_id   = "publisher"
    display_name = "publisher"
}

resource "google_service_account" "config" {
    account_id   = "config"
    display_name = "config"
}

resource "google_project_iam_policy" "publish" {
    policy_data = "${data.google_iam_policy.publisher.policy_data}"
}

resource "google_project_iam_policy" "config" {
    policy_data = "${data.google_iam_policy.config.policy_data}"
}

data "google_iam_policy" "publisher" {
    binding {
        role = "roles/pubsub.publisher"

        members = [
            "serviceAccount:${google_service_account.publisher.email}"
        ]
    }
}

data "google_iam_policy" "config" {
    binding {
        role = "roles/storage.objectAdmin"

        members = [
            "serviceAccount:${google_service_account.config.email}"
        ]
    }
}

# create service account key file

