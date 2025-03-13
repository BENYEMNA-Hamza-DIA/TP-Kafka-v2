provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_instance" "kafka_vm" {
  name         = "kafka-tp-vm"
  machine_type = "e2-medium"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<EOT
#!/bin/bash
apt update && apt install -y git
git clone ${var.gitlab_repo} /home/kafka-tp
cd /home/kafka-tp
chmod +x scripts/install_dependencies.sh
./scripts/install_dependencies.sh
./scripts/run_kafka_pipeline.sh
EOT
}

output "vm_external_ip" {
  value = google_compute_instance.kafka_vm.network_interface[0].access_config[0].nat_ip
}
