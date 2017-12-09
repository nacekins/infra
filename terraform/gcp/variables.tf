variable "project" {
    description = "The GCP project id for the corresponding environment"
}

variable "region" {
    description = "The GCP region"
    default = "europe-west-1"
}

variable "bucket-config-location" {
    description = "Location of bucket for config"
}

variable "bucket-config-name" {
    description = "Name of bucket for config"
}

variable "endpoint-api-stats" {
    description = "stats webhook for push issue"
}

variable "endpoint-notifier" {
    description = "notifier webhook for push issue"
}

