resource "scaleway_server" "vps" {
    name  = "simone"
    image = "${data.scaleway_image.docker.id}"
    type  = "VC1S"

    dynamic_ip_required = true
}

data "scaleway_image" "docker" {
    architecture = "x86_64"
    name         = "Docker"
}

