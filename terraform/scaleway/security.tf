resource "scaleway_security_group" "firewall" {
    name        = "train.cat firewall"
    description = "Firewall rules for train.cat"
}

# Allow SSH (need open 22 for configure ssh the first time)
resource "scaleway_security_group_rule" "default_ssh" {
    count = "${length(var.trusted_ips)}"

    security_group = "${scaleway_security_group.firewall.id}"

    action    = "accept"
    direction = "inbound"
    ip_range  = "${element(var.trusted_ips, count.index)}"
    protocol  = "TCP"
    port      = 22
}

# Allow SSH in
resource "scaleway_security_group_rule" "ssh_in" {
    count = "${length(var.trusted_ips)}"

    security_group = "${scaleway_security_group.firewall.id}"

    action    = "accept"
    direction = "inbound"
    ip_range  = "${element(var.trusted_ips, count.index)}"
    protocol  = "TCP"
    port      = "${var.ssh_port}"

    depends_on = ["scaleway_security_group_rule.default_ssh"]
}

# Allow SSH out
resource "scaleway_security_group_rule" "default_ssh_out" {
    security_group = "${scaleway_security_group.firewall.id}"

    action    = "accept"
    direction = "outbound"
    ip_range  = "0.0.0.0/0"
    protocol  = "TCP"
    port      = 22

    depends_on = ["scaleway_security_group_rule.ssh_in"]
}

# Allow web out
resource "scaleway_security_group_rule" "http_out" {
    security_group = "${scaleway_security_group.firewall.id}"

    action    = "accept"
    direction = "outbound"
    ip_range  = "0.0.0.0/0"
    protocol  = "TCP"
    port      = 80

    depends_on = ["scaleway_security_group_rule.default_ssh_out"]
}

resource "scaleway_security_group_rule" "https_out" {
    security_group = "${scaleway_security_group.firewall.id}"

    action    = "accept"
    direction = "outbound"
    ip_range  = "0.0.0.0/0"
    protocol  = "TCP"
    port      = 443

    depends_on = ["scaleway_security_group_rule.http_out"]
}

# Allow web in
resource "scaleway_security_group_rule" "http_in" {
    security_group = "${scaleway_security_group.firewall.id}"

    action    = "accept"
    direction = "inbound"
    ip_range  = "0.0.0.0/0"
    protocol  = "TCP"
    port      = 80

    depends_on = ["scaleway_security_group_rule.https_out"]
}

resource "scaleway_security_group_rule" "https_in" {
    security_group = "${scaleway_security_group.firewall.id}"

    action    = "accept"
    direction = "inbound"
    ip_range  = "0.0.0.0/0"
    protocol  = "TCP"
    port      = 443

    depends_on = ["scaleway_security_group_rule.http_in"]
}

# Allow DNS
resource "scaleway_security_group_rule" "dns_out" {
    security_group = "${scaleway_security_group.firewall.id}"

    action    = "accept"
    direction = "outbound"
    ip_range  = "0.0.0.0/0"
    protocol  = "TCP"
    port      = 53

    depends_on = ["scaleway_security_group_rule.https_in"]
}

# Allow NTP
resource "scaleway_security_group_rule" "ntp_out" {
    security_group = "${scaleway_security_group.firewall.id}"

    action    = "accept"
    direction = "outbound"
    ip_range  = "0.0.0.0/0"
    protocol  = "UDP"
    port      = 123

    depends_on = ["scaleway_security_group_rule.dns_out"]
}

# Allow admin interface traefik
resource "scaleway_security_group_rule" "traefik_admin_in" {
    count = "${length(var.trusted_ips)}"

    security_group = "${scaleway_security_group.firewall.id}"

    action    = "accept"
    direction = "inbound"
    ip_range  = "${element(var.trusted_ips, count.index)}"
    protocol  = "TCP"
    port      = "${var.traefik_admin_port}"

    depends_on = ["scaleway_security_group_rule.ntp_out"]
}

# Allow ping
resource "scaleway_security_group_rule" "ping_in" {
    security_group = "${scaleway_security_group.firewall.id}"

    action    = "accept"
    direction = "inbound"
    ip_range  = "0.0.0.0/0"
    protocol  = "ICMP"

    depends_on = ["scaleway_security_group_rule.traefik_admin_in"]
}

# Disallow other tcp in
resource "scaleway_security_group_rule" "drop_tcp_in" {
    security_group = "${scaleway_security_group.firewall.id}"

    action    = "drop"
    direction = "inbound"
    ip_range  = "0.0.0.0/0"
    protocol  = "TCP"

    depends_on = ["scaleway_security_group_rule.ping_in"]
}

# Disallow other tcp out
resource "scaleway_security_group_rule" "drop_tcp_out" {
    security_group = "${scaleway_security_group.firewall.id}"

    action    = "drop"
    direction = "outbound"
    ip_range  = "0.0.0.0/0"
    protocol  = "TCP"

    depends_on = ["scaleway_security_group_rule.drop_tcp_in"]
}

# Disallow other udp in
resource "scaleway_security_group_rule" "drop_udp_in" {
    security_group = "${scaleway_security_group.firewall.id}"

    action = "drop"
    direction = "inbound"
    ip_range = "0.0.0.0/0"
    protocol = "UDP"

    depends_on = ["scaleway_security_group_rule.drop_tcp_out"]
}

# Disallow other udp out
resource "scaleway_security_group_rule" "drop_udp_out" {
    security_group = "${scaleway_security_group.firewall.id}"

    action    = "drop"
    direction = "outbound"
    ip_range  = "0.0.0.0/0"
    protocol  = "UDP"

    depends_on = ["scaleway_security_group_rule.drop_udp_in"]
}

