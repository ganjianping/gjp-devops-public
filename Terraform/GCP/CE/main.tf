locals {
  image_config = {
    ubuntu = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    debian = "debian-cloud/debian-12"
    centos = "centos-cloud/centos-stream-9"
    rhel   = "rhel-cloud/rhel-9"
    windows-2022 = "windows-cloud/windows-2022"
    windows-2019 = "windows-cloud/windows-2019"
  }
}

# Data source to get default network if not specified
data "google_compute_network" "default" {
  name = var.network == "" ? "default" : var.network
}

# Firewall rule for SSH
resource "google_compute_firewall" "ssh" {
  name    = "${var.instance_name}-${var.environment}-allow-ssh"
  network = data.google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.allowed_ssh_cidr
  target_tags   = ["${var.instance_name}-ssh"]
}

# Firewall rule for other TCP ports
resource "google_compute_firewall" "tcp_ports" {
  count   = length(var.open_tcp_ports) > 0 ? 1 : 0
  name    = "${var.instance_name}-${var.environment}-allow-tcp"
  network = data.google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = [for port in var.open_tcp_ports : tostring(port)]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.instance_name}-tcp"]
}

resource "google_compute_instance" "instance" {
  name         = "${var.instance_name}-${var.environment}"
  machine_type = var.machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = var.image != "" ? var.image : local.image_config[var.os_type]
      size  = var.disk_size_gb
      type  = var.disk_type
    }
  }

  network_interface {
    network    = data.google_compute_network.default.name
    subnetwork = var.subnetwork == "" ? null : var.subnetwork

    dynamic "access_config" {
      for_each = var.enable_public_ip ? [1] : []
      content {
        // Ephemeral public IP
      }
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
  }

  tags = concat(
    ["${var.instance_name}-ssh"],
    length(var.open_tcp_ports) > 0 ? ["${var.instance_name}-tcp"] : [],
    var.tags
  )

  dynamic "scheduling" {
    for_each = var.use_spot_instance ? [1] : []
    content {
      preemptible                 = true
      provisioning_model          = "SPOT"
      automatic_restart           = false
      instance_termination_action = "STOP"
    }
  }

  labels = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
    },
    var.additional_labels
  )
}
