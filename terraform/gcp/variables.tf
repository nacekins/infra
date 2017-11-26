variable "project" {
    description = "The GCP project id for the corresponding environment"
}

variable "region" {
    description = "The GCP region"
    default = "europe-west-1"
}

variable "endpoint-api-stats" {
    description = "stats webhook for push issue"
}

variable "endpoint-notifier" {
    description = "notifier webhook for push issue"
}

