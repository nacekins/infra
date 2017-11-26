resource "google_pubsub_topic" "issue" {
    name = "issue"
}

resource "google_pubsub_subscription" "api-stats" {
    name  = "stats"
    topic = "${google_pubsub_topic.issue.name}"

    ack_deadline_seconds = 10

    push_config {
        push_endpoint = "${var.endpoint-api-stats}"
    }
}

resource "google_pubsub_subscription" "notifier" {
    name  = "notifier"
    topic = "${google_pubsub_topic.issue.name}"

    ack_deadline_seconds = 10

    push_config {
        push_endpoint = "${var.endpoint-notifier}"
    }
}

