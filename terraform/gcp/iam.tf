resource "google_service_account" "publisher" {
    account_id   = "publisher"
    display_name = "publisher"
}

resource "google_project_iam_policy" "publish" {
    policy_data = "${data.google_iam_policy.publisher.policy_data}"
}

data "google_iam_policy" "publisher" {
    binding {
        role = "roles/pubsub.publisher"

        members = [
            "serviceAccount:${google_service_account.publisher.email}"
        ]
    }
}

# create service account key file

