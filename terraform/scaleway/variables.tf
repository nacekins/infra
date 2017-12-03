variable "organization" {
    description = "Scaleway access key"
}

variable "token" {
    description = "Scaleway token"
}

variable "region" {
    description = "Scaleway region"
}

variable "trusted_ips" {
    type        = "list"
    description = "List of allowed IP for ssh"
}

variable "ssh_port" {
    description = "SSH port"
}

variable "traefik_admin_port" {
    description = "Port for admin interface of traefik"
}

